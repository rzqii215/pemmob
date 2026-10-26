import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

class FormKegiatanPage extends StatefulWidget {
  const FormKegiatanPage({
    super.key,
    this.kegiatan,
  });

  final Kegiatan? kegiatan;

  @override
  State<FormKegiatanPage> createState() {
    return _FormKegiatanPageState();
  }
}

class _FormKegiatanPageState extends State<FormKegiatanPage> {
  static const List<String> kategoriPengeluaran = [
    'Makan',
    'Transport',
    'Belajar',
    'Hiburan',
    'Lainnya',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _judulController;
  late final TextEditingController _nominalController;

  late DateTime _tanggal;
  late Tipe _tipe;
  late String _kategori;

  bool _sedangMenyimpan = false;

  @override
  void initState() {
    super.initState();

    final kegiatan = widget.kegiatan;

    _judulController = TextEditingController(
      text: kegiatan?.judul ?? '',
    );

    _nominalController = TextEditingController(
      text: kegiatan != null && kegiatan.tipe != Tipe.tanpa
          ? kegiatan.nominal.toString()
          : '',
    );

    _tanggal =
        kegiatan == null ? DateTime.now() : DateTime.parse(kegiatan.tanggal);

    _tipe = kegiatan?.tipe ?? Tipe.tanpa;

    _kategori = kegiatan?.tipe == Tipe.pengeluaran
        ? kegiatan!.kategori
        : kategoriPengeluaran.first;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _nominalController.dispose();

    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final terpilih = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (terpilih != null && mounted) {
      setState(() {
        _tanggal = terpilih;
      });
    }
  }

  String? _validasiNominal(String? teks) {
    if (_tipe == Tipe.tanpa) {
      return null;
    }

    final nominal = int.tryParse(
      (teks ?? '').trim(),
    );

    if (nominal == null || nominal <= 0) {
      return 'Nominal harus berupa angka lebih dari 0.';
    }

    return null;
  }

  Future<void> _simpan() async {
    if (_sedangMenyimpan) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _sedangMenyimpan = true;
    });

    final kegiatan = Kegiatan(
      id: widget.kegiatan?.id,
      judul: _judulController.text.trim(),
      tanggal: formatTanggalDatabase(_tanggal),
      selesai: widget.kegiatan?.selesai ?? false,
      tipe: _tipe,
      nominal:
          _tipe == Tipe.tanpa ? 0 : int.parse(_nominalController.text.trim()),
      kategori: _tipe == Tipe.pengeluaran ? _kategori : '-',
    );

    try {
      if (widget.kegiatan == null) {
        await DbHelper.tambah(kegiatan);
      } else {
        await DbHelper.ubah(kegiatan);
      }

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan kegiatan: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sedangMenyimpan = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool adalahUbah = widget.kegiatan != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          adalahUbah ? 'Ubah Kegiatan' : 'Tambah Kegiatan',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Detail Kegiatan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Catat kegiatan harian beserta '
              'pemasukan atau pengeluarannya.',
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _judulController,
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nama Kegiatan',
                hintText: 'Contoh: Belajar Flutter',
                prefixIcon: Icon(Icons.edit_note),
              ),
              validator: (nilai) {
                if (nilai == null || nilai.trim().isEmpty) {
                  return 'Nama kegiatan wajib diisi.';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pilihTanggal,
              icon: const Icon(
                Icons.calendar_month_outlined,
              ),
              label: Text(
                'Tanggal: ${formatTanggal(_tanggal)}',
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Tipe>(
              initialValue: _tipe,
              decoration: const InputDecoration(
                labelText: 'Jenis Keuangan',
                prefixIcon: Icon(
                  Icons.account_balance_wallet_outlined,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: Tipe.tanpa,
                  child: Text(
                    'Tidak melibatkan uang',
                  ),
                ),
                DropdownMenuItem(
                  value: Tipe.pemasukan,
                  child: Text('Pemasukan'),
                ),
                DropdownMenuItem(
                  value: Tipe.pengeluaran,
                  child: Text('Pengeluaran'),
                ),
              ],
              onChanged: (nilai) {
                if (nilai == null) {
                  return;
                }

                setState(() {
                  _tipe = nilai;
                });
              },
            ),
            if (_tipe != Tipe.tanpa) ...[
              const SizedBox(height: 20),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Nominal (Rp)',
                  hintText: 'Contoh: 50000',
                  prefixIcon: Icon(
                    Icons.payments_outlined,
                  ),
                ),
                validator: _validasiNominal,
              ),
            ],
            if (_tipe == Tipe.pengeluaran) ...[
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori Pengeluaran',
                  prefixIcon: Icon(
                    Icons.category_outlined,
                  ),
                ),
                items: kategoriPengeluaran.map((kategori) {
                  return DropdownMenuItem<String>(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
                onChanged: (nilai) {
                  if (nilai == null) {
                    return;
                  }

                  setState(() {
                    _kategori = nilai;
                  });
                },
              ),
            ],
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _sedangMenyimpan ? null : _simpan,
              icon: _sedangMenyimpan
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                adalahUbah ? 'Simpan Perubahan' : 'Simpan Kegiatan',
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
