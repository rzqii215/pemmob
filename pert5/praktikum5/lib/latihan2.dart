import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Praktikum 5',
      home: CatatanPage(),
    );
  }
}

// =====================================
// BAGIAN B - MODEL CATATAN
// =====================================

class Catatan {
  final int? id;
  final String judul;
  final String isi;

  const Catatan({
    this.id,
    required this.judul,
    required this.isi,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'judul': judul,
    'isi': isi,
  };

  factory Catatan.fromMap(Map<String, Object?> m) => Catatan(
    id: m['id'] as int,
    judul: m['judul'] as String,
    isi: m['isi'] as String,
  );
}

// =====================================
// BAGIAN B - DATABASE SQLITE
// =====================================

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final path = p.join(
      await getDatabasesPath(),
      'catatan.db',
    );

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE catatan('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'judul TEXT NOT NULL, '
              'isi TEXT NOT NULL)',
        );
      },
    );

    return _db!;
  }

  static Future<int> tambah(Catatan c) async {
    final db = await database;
    return db.insert('catatan', c.toMap());
  }

  static Future<List<Catatan>> semua() async {
    final db = await database;
    final rows = await db.query(
      'catatan',
      orderBy: 'id DESC',
    );

    return rows.map(Catatan.fromMap).toList();
  }

  // =====================================
  // LATIHAN MANDIRI NOMOR 2
  // PENCARIAN BERDASARKAN JUDUL
  // =====================================

  static Future<List<Catatan>> cari(String kata) async {
    final db = await database;

    final rows = await db.query(
      'catatan',
      where: 'judul LIKE ?',
      whereArgs: ['%$kata%'],
      orderBy: 'id DESC',
    );

    return rows.map(Catatan.fromMap).toList();
  }

  static Future<int> ubah(Catatan c) async {
    final db = await database;
    return db.update(
      'catatan',
      c.toMap(),
      where: 'id = ?',
      whereArgs: [c.id],
    );
  }

  static Future<int> hapus(int id) async {
    final db = await database;
    return db.delete(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

// =====================================
// BAGIAN C - HALAMAN DAFTAR CATATAN
// =====================================

class CatatanPage extends StatefulWidget {
  const CatatanPage({super.key});

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  late Future<List<Catatan>> _future;

  // LATIHAN MANDIRI NOMOR 2
  final _cariController = TextEditingController();
  String _kata = '';

  @override
  void initState() {
    super.initState();
    _future = DbHelper.semua();
  }

  @override
  void dispose() {
    _cariController.dispose();
    super.dispose();
  }

  void _muat() {
    setState(() {
      if (_kata.isEmpty) {
        _future = DbHelper.semua();
      } else {
        _future = DbHelper.cari(_kata);
      }
    });
  }

  // LATIHAN MANDIRI NOMOR 2
  void _cariCatatan(String kata) {
    _kata = kata.trim();
    _muat();
  }

  Future<void> _buka([Catatan? catatan]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormCatatanPage(catatan: catatan),
      ),
    );

    if (!mounted) return;
    _muat();
  }

  // LATIHAN MANDIRI NOMOR 1
  Future<void> _konfirmasiHapus(Catatan catatan) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Hapus catatan ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (yakin == true) {
      await DbHelper.hapus(catatan.id!);

      if (!mounted) return;
      _muat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Saya'),
      ),
      body: Column(
        children: [
          // LATIHAN MANDIRI NOMOR 2
          // KOLOM PENCARIAN
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _cariController,
              decoration: const InputDecoration(
                labelText: 'Cari Judul Catatan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _cariCatatan,
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Catatan>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Galat: ${snapshot.error}'),
                  );
                }

                final data = snapshot.data!;

                if (data.isEmpty) {
                  return const Center(
                    child: Text('Belum ada catatan'),
                  );
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    final c = data[i];

                    return ListTile(
                      title: Text(c.judul),
                      subtitle: Text(
                        c.isi,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _buka(c),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _konfirmasiHapus(c),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _buka(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// =====================================
// BAGIAN D - FORM TAMBAH DAN UBAH
// =====================================

class FormCatatanPage extends StatefulWidget {
  final Catatan? catatan;

  const FormCatatanPage({
    super.key,
    this.catatan,
  });

  @override
  State<FormCatatanPage> createState() =>
      _FormCatatanPageState();
}

class _FormCatatanPageState extends State<FormCatatanPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _judul;
  late final TextEditingController _isi;

  @override
  void initState() {
    super.initState();

    _judul = TextEditingController(
      text: widget.catatan?.judul ?? '',
    );

    _isi = TextEditingController(
      text: widget.catatan?.isi ?? '',
    );
  }

  @override
  void dispose() {
    _judul.dispose();
    _isi.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final c = Catatan(
      id: widget.catatan?.id,
      judul: _judul.text.trim(),
      isi: _isi.text.trim(),
    );

    if (widget.catatan == null) {
      await DbHelper.tambah(c);
    } else {
      await DbHelper.ubah(c);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final baru = widget.catatan == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          baru ? 'Catatan Baru' : 'Ubah Catatan',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judul,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty)
                  ? 'Judul wajib diisi'
                  : null,
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _isi,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Isi catatan',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty)
                  ? 'Isi wajib diisi'
                  : null,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _simpan,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}