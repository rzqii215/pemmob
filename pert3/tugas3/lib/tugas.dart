import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Barang {
  String nama;
  int jumlah;
  String kategori;
  bool sudahDibeli;

  Barang(
      this.nama,
      this.jumlah,
      this.kategori, {
        this.sudahDibeli = false,
      });
}

class BelanjaModel extends ChangeNotifier {
  final List<Barang> _items = [];

  List<Barang> get items => List.unmodifiable(_items);

  int get jumlahBelumDibeli =>
      _items.where((barang) => !barang.sudahDibeli).length;

  void tambah(String nama, int jumlah, String kategori) {
    _items.add(
      Barang(
        nama,
        jumlah,
        kategori,
      ),
    );
    notifyListeners();
  }

  void toggle(int index) {
    _items[index].sudahDibeli =
    !_items[index].sudahDibeli;

    notifyListeners();
  }

  void hapus(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BelanjaModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Belanja',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const DaftarBelanjaPage(),
    );
  }
}

class DaftarBelanjaPage extends StatelessWidget {
  const DaftarBelanjaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BelanjaModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Belum Dibeli (${model.jumlahBelumDibeli})',
        ),
      ),
      body: ListView.builder(
        itemCount: model.items.length,
        itemBuilder: (context, index) {
          final barang = model.items[index];

          return ListTile(
            leading: Checkbox(
              value: barang.sudahDibeli,
              onChanged: (_) {
                context.read<BelanjaModel>().toggle(index);
              },
            ),
            title: Text(
              barang.nama,
              style: TextStyle(
                decoration: barang.sudahDibeli
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            subtitle: Text(
              'Jumlah: ${barang.jumlah} | Kategori: ${barang.kategori}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<BelanjaModel>().hapus(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahBarangPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() =>
      _TambahBarangPageState();
}

class _TambahBarangPageState
    extends State<TambahBarangPage> {
  final _formKey = GlobalKey<FormState>();

  final _nama = TextEditingController();
  final _jumlah = TextEditingController();

  String? _kategori;

  @override
  void dispose() {
    _nama.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      context.read<BelanjaModel>().tambah(
        _nama.text.trim(),
        int.parse(_jumlah.text),
        _kategori!,
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nama,
              decoration: const InputDecoration(
                labelText: 'Nama barang',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Nama barang wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _jumlah,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Jumlah wajib diisi';
                }

                final jumlah = int.tryParse(v);

                if (jumlah == null || jumlah <= 0) {
                  return 'Jumlah harus angka lebih dari 0';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Makanan',
                  child: Text('Makanan'),
                ),
                DropdownMenuItem(
                  value: 'Minuman',
                  child: Text('Minuman'),
                ),
                DropdownMenuItem(
                  value: 'Lainnya',
                  child: Text('Lainnya'),
                ),
              ],
              onChanged: (v) {
                setState(() {
                  _kategori = v;
                });
              },
              validator: (v) {
                if (v == null) {
                  return 'Kategori wajib dipilih';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

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