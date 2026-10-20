import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

// =====================================
// PENGATURAN MODE GELAP
// =====================================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _gelap = false;

  @override
  void initState() {
    super.initState();
    _muatTema();
  }

  Future<void> _muatTema() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _gelap = prefs.getBool('modeGelap') ?? false;
    });
  }

  Future<void> _ubahTema(bool nilai) async {
    setState(() {
      _gelap = nilai;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', nilai);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pencatat Pengeluaran',
      theme: ThemeData(
        brightness:
        _gelap ? Brightness.dark : Brightness.light,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: PengeluaranPage(
        gelap: _gelap,
        onUbahTema: _ubahTema,
      ),
    );
  }
}

// =====================================
// MODEL PENGELUARAN
// =====================================

class Pengeluaran {
  final int? id;
  final String nama;
  final int jumlah;
  final String kategori;
  final String tanggal;

  const Pengeluaran({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.kategori,
    required this.tanggal,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'nama': nama,
    'jumlah': jumlah,
    'kategori': kategori,
    'tanggal': tanggal,
  };

  factory Pengeluaran.fromMap(
      Map<String, Object?> m,
      ) =>
      Pengeluaran(
        id: m['id'] as int,
        nama: m['nama'] as String,
        jumlah: m['jumlah'] as int,
        kategori: m['kategori'] as String,
        tanggal: m['tanggal'] as String,
      );
}

// =====================================
// DATABASE SQLITE
// =====================================

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final path = p.join(
      await getDatabasesPath(),
      'pengeluaran.db',
    );

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE pengeluaran('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'nama TEXT NOT NULL, '
              'jumlah INTEGER NOT NULL, '
              'kategori TEXT NOT NULL, '
              'tanggal TEXT NOT NULL)',
        );
      },
    );

    return _db!;
  }

  // CREATE
  static Future<int> tambah(Pengeluaran data) async {
    final db = await database;
    return db.insert(
      'pengeluaran',
      data.toMap(),
    );
  }

  // READ
  static Future<List<Pengeluaran>> semua() async {
    final db = await database;

    final rows = await db.query(
      'pengeluaran',
      orderBy: 'id DESC',
    );

    return rows.map(Pengeluaran.fromMap).toList();
  }

  // UPDATE
  static Future<int> ubah(Pengeluaran data) async {
    final db = await database;

    return db.update(
      'pengeluaran',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  // DELETE
  static Future<int> hapus(int id) async {
    final db = await database;

    return db.delete(
      'pengeluaran',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

// =====================================
// HALAMAN DAFTAR PENGELUARAN
// =====================================

class PengeluaranPage extends StatefulWidget {
  final bool gelap;
  final ValueChanged<bool> onUbahTema;

  const PengeluaranPage({
    super.key,
    required this.gelap,
    required this.onUbahTema,
  });

  @override
  State<PengeluaranPage> createState() =>
      _PengeluaranPageState();
}

class _PengeluaranPageState
    extends State<PengeluaranPage> {
  late Future<List<Pengeluaran>> _future;

  @override
  void initState() {
    super.initState();
    _future = DbHelper.semua();
  }

  void _muat() {
    setState(() {
      _future = DbHelper.semua();
    });
  }

  // MEMBUKA FORM TAMBAH ATAU UBAH
  Future<void> _buka([Pengeluaran? data]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormPengeluaranPage(
          pengeluaran: data,
        ),
      ),
    );

    if (!mounted) return;
    _muat();
  }

  // MENGHAPUS PENGELUARAN
  Future<void> _hapus(int id) async {
    await DbHelper.hapus(id);

    if (!mounted) return;
    _muat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencatat Pengeluaran'),
      ),
      body: Column(
        children: [
          // PENGATURAN SHAREDPREFERENCES
          SwitchListTile(
            title: const Text('Mode gelap'),
            value: widget.gelap,
            onChanged: widget.onUbahTema,
          ),

          // DAFTAR DAN TOTAL PENGELUARAN
          Expanded(
            child: FutureBuilder<List<Pengeluaran>>(
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
                    child: Text(
                      'Galat: ${snapshot.error}',
                    ),
                  );
                }

                final data = snapshot.data!;

                // MENGHITUNG TOTAL DI DART
                final total = data.fold<int>(
                  0,
                      (jumlah, item) =>
                  jumlah + item.jumlah,
                );

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Total Pengeluaran',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp $total',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: data.isEmpty
                          ? const Center(
                        child: Text(
                          'Belum ada pengeluaran',
                        ),
                      )
                          : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          final item = data[i];

                          return ListTile(
                            title: Text(item.nama),
                            subtitle: Text(
                              '${item.kategori}\n'
                                  '${item.tanggal}',
                            ),
                            isThreeLine: true,
                            onTap: () => _buka(item),
                            trailing: Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                Text(
                                  'Rp ${item.jumlah}',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                  onPressed: () =>
                                      _hapus(
                                        item.id!,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
// FORM TAMBAH DAN UBAH PENGELUARAN
// =====================================

class FormPengeluaranPage extends StatefulWidget {
  final Pengeluaran? pengeluaran;

  const FormPengeluaranPage({
    super.key,
    this.pengeluaran,
  });

  @override
  State<FormPengeluaranPage> createState() =>
      _FormPengeluaranPageState();
}

class _FormPengeluaranPageState
    extends State<FormPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nama;
  late final TextEditingController _jumlah;

  String? _kategori;

  // CONTOH KATEGORI UNTUK DROPDOWN
  final List<String> _kategoriList = [
    'Makanan',
    'Transportasi',
    'Belanja',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();

    _nama = TextEditingController(
      text: widget.pengeluaran?.nama ?? '',
    );

    _jumlah = TextEditingController(
      text:
      widget.pengeluaran?.jumlah.toString() ?? '',
    );

    _kategori = widget.pengeluaran?.kategori;
  }

  @override
  void dispose() {
    _nama.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  // =====================================
  // VALIDASI DAN SIMPAN PENGELUARAN
  // =====================================

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final data = Pengeluaran(
      id: widget.pengeluaran?.id,
      nama: _nama.text.trim(),
      jumlah: int.parse(_jumlah.text.trim()),
      kategori: _kategori!,
      tanggal: widget.pengeluaran?.tanggal ??
          DateTime.now().toIso8601String(),
    );

    if (widget.pengeluaran == null) {
      await DbHelper.tambah(data);
    } else {
      await DbHelper.ubah(data);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final baru = widget.pengeluaran == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          baru
              ? 'Tambah Pengeluaran'
              : 'Ubah Pengeluaran',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // NAMA PENGELUARAN
            TextFormField(
              controller: _nama,
              decoration: const InputDecoration(
                labelText: 'Nama Pengeluaran',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty)
                  ? 'Nama wajib diisi'
                  : null,
            ),

            const SizedBox(height: 12),

            // JUMLAH PENGELUARAN
            TextFormField(
              controller: _jumlah,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Pengeluaran',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Jumlah wajib diisi';
                }

                final angka = int.tryParse(v.trim());

                if (angka == null) {
                  return 'Jumlah harus berupa angka';
                }

                if (angka <= 0) {
                  return 'Jumlah harus lebih dari 0';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            // KATEGORI DENGAN DROPDOWN
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: _kategoriList.map((kategori) {
                return DropdownMenuItem<String>(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              onChanged: (nilai) {
                setState(() {
                  _kategori = nilai;
                });
              },
              validator: (v) {
                if (v == null) {
                  return 'Kategori wajib dipilih';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // TOMBOL SIMPAN
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