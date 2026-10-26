import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kegiatan.dart';
import '../utils/format.dart';

final ValueNotifier<int> versiData = ValueNotifier<int>(0);

class DbHelper {
  DbHelper._();

  static Future<Database>? _databaseAktif;

  static Future<Database> get _database {
    return _databaseAktif ??= _bukaDatabase();
  }

  static Future<Database> _bukaDatabase() async {
    final folder = await getDatabasesPath();

    return openDatabase(
      '$folder/tabungku.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE kegiatan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            tanggal TEXT NOT NULL,
            selesai INTEGER NOT NULL DEFAULT 0,
            tipe TEXT NOT NULL,
            nominal INTEGER NOT NULL DEFAULT 0,
            kategori TEXT NOT NULL DEFAULT '-'
          )
        ''');
      },
    );
  }

  static Future<int> tambah(Kegiatan kegiatan) async {
    final db = await _database;

    final id = await db.insert(
      'kegiatan',
      kegiatan.toMap(),
    );

    versiData.value++;

    return id;
  }

  static Future<int> ubah(Kegiatan kegiatan) async {
    if (kegiatan.id == null) {
      throw ArgumentError('ID kegiatan tidak ditemukan.');
    }

    final db = await _database;

    final jumlah = await db.update(
      'kegiatan',
      kegiatan.toMap(),
      where: 'id = ?',
      whereArgs: [kegiatan.id],
    );

    if (jumlah > 0) {
      versiData.value++;
    }

    return jumlah;
  }

  static Future<int> ubahSelesai(
    int id,
    bool selesai,
  ) async {
    final db = await _database;

    final jumlah = await db.update(
      'kegiatan',
      {
        'selesai': selesai ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    if (jumlah > 0) {
      versiData.value++;
    }

    return jumlah;
  }

  static Future<int> hapus(int id) async {
    final db = await _database;

    final jumlah = await db.delete(
      'kegiatan',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (jumlah > 0) {
      versiData.value++;
    }

    return jumlah;
  }

  static Future<List<Kegiatan>> pada(
    String tanggal,
  ) async {
    final db = await _database;

    final hasil = await db.query(
      'kegiatan',
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'selesai ASC, id DESC',
    );

    return hasil.map(Kegiatan.fromMap).toList();
  }

  static Future<List<Kegiatan>> cariPada(
    String tanggal, {
    String pencarian = '',
    Tipe? tipe,
  }) async {
    final db = await _database;

    final syarat = <String>[
      'tanggal = ?',
    ];

    final argumen = <Object?>[
      tanggal,
    ];

    if (pencarian.trim().isNotEmpty) {
      syarat.add(
        '(judul LIKE ? OR kategori LIKE ?)',
      );

      final kata = '%${pencarian.trim()}%';

      argumen.addAll([
        kata,
        kata,
      ]);
    }

    if (tipe != null) {
      syarat.add('tipe = ?');
      argumen.add(tipe.name);
    }

    final hasil = await db.query(
      'kegiatan',
      where: syarat.join(' AND '),
      whereArgs: argumen,
      orderBy: 'selesai ASC, id DESC',
    );

    return hasil.map(Kegiatan.fromMap).toList();
  }

  static Future<Ringkasan> ringkasan(
    String tanggal,
  ) async {
    final db = await _database;

    final hasil = await db.rawQuery('''
      SELECT COUNT(*) AS jumlah,
             COALESCE(SUM(selesai), 0) AS selesai,
             COALESCE(
               SUM(
                 CASE
                   WHEN tipe = 'pemasukan'
                   THEN nominal
                 END
               ), 0
             ) AS masuk,
             COALESCE(
               SUM(
                 CASE
                   WHEN tipe = 'pengeluaran'
                   THEN nominal
                 END
               ), 0
             ) AS keluar
      FROM kegiatan
      WHERE tanggal = ?
    ''', [tanggal]);

    final baris = hasil.first;

    return Ringkasan(
      jumlahKegiatan: baris['jumlah'] as int,
      selesai: baris['selesai'] as int,
      pemasukan: baris['masuk'] as int,
      pengeluaran: baris['keluar'] as int,
    );
  }

  static Future<Map<String, int>> pengeluaranPerKategori(
    String tanggal,
  ) async {
    final db = await _database;

    final hasil = await db.rawQuery('''
      SELECT kategori,
             COALESCE(SUM(nominal), 0) AS total
      FROM kegiatan
      WHERE tanggal = ?
        AND tipe = 'pengeluaran'
      GROUP BY kategori
      ORDER BY total DESC, kategori ASC
    ''', [tanggal]);

    return {
      for (final baris in hasil)
        baris['kategori'] as String: baris['total'] as int,
    };
  }

  static Future<List<LaporanHari>> tujuhHari() async {
    final db = await _database;

    final sekarang = DateTime.now();

    final hariIni = DateTime(
      sekarang.year,
      sekarang.month,
      sekarang.day,
    );

    final awal = hariIni.subtract(
      const Duration(days: 6),
    );

    final hasil = await db.rawQuery('''
      SELECT tanggal,
             COALESCE(
               SUM(
                 CASE
                   WHEN tipe = 'pemasukan'
                   THEN nominal
                 END
               ), 0
             ) AS masuk,
             COALESCE(
               SUM(
                 CASE
                   WHEN tipe = 'pengeluaran'
                   THEN nominal
                 END
               ), 0
             ) AS keluar
      FROM kegiatan
      WHERE tanggal BETWEEN ? AND ?
      GROUP BY tanggal
      ORDER BY tanggal ASC
    ''', [
      formatTanggalDatabase(awal),
      formatTanggalDatabase(hariIni),
    ]);

    final laporan = <String, LaporanHari>{};

    for (final baris in hasil) {
      final tanggal = baris['tanggal'] as String;

      laporan[tanggal] = LaporanHari(
        tanggal: tanggal,
        pemasukan: baris['masuk'] as int,
        pengeluaran: baris['keluar'] as int,
      );
    }

    return List.generate(7, (index) {
      final tanggal = formatTanggalDatabase(
        awal.add(Duration(days: index)),
      );

      return laporan[tanggal] ??
          LaporanHari(
            tanggal: tanggal,
            pemasukan: 0,
            pengeluaran: 0,
          );
    });
  }
}
