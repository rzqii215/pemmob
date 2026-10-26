import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/kegiatan_tile.dart';
import '../widgets/ringkasan_card.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({
    super.key,
    required this.pengaturan,
  });

  final Pengaturan pengaturan;

  @override
  State<BerandaPage> createState() {
    return _BerandaPageState();
  }
}

class _DataHari {
  const _DataHari({
    required this.kegiatan,
    required this.ringkasan,
  });

  final List<Kegiatan> kegiatan;
  final Ringkasan ringkasan;
}

class _BerandaPageState extends State<BerandaPage> {
  late Future<_DataHari> _future;

  final TextEditingController _pencarianController = TextEditingController();

  Tipe? _filterTipe;

  @override
  void initState() {
    super.initState();

    _future = _ambil();

    versiData.addListener(_muat);
  }

  @override
  void dispose() {
    versiData.removeListener(_muat);
    _pencarianController.dispose();

    super.dispose();
  }

  Future<_DataHari> _ambil() async {
    final tanggal = formatTanggalDatabase(
      DateTime.now(),
    );

    final bool adaFilter =
        _pencarianController.text.trim().isNotEmpty || _filterTipe != null;

    final List<Kegiatan> kegiatan;

    if (adaFilter) {
      kegiatan = await DbHelper.cariPada(
        tanggal,
        pencarian: _pencarianController.text,
        tipe: _filterTipe,
      );
    } else {
      kegiatan = await DbHelper.pada(tanggal);
    }

    final ringkasan = await DbHelper.ringkasan(
      tanggal,
    );

    return _DataHari(
      kegiatan: kegiatan,
      ringkasan: ringkasan,
    );
  }

  void _muat() {
    if (!mounted) {
      return;
    }

    setState(() {
      _future = _ambil();
    });
  }

  Future<void> _centang(
    Kegiatan kegiatan,
    bool selesai,
  ) async {
    if (kegiatan.id == null) {
      return;
    }

    try {
      await DbHelper.ubahSelesai(
        kegiatan.id!,
        selesai,
      );
    } catch (error) {
      _tampilkanGalat(
        'Gagal mengubah status: $error',
      );
    }
  }

  Future<void> _hapus(Kegiatan kegiatan) async {
    if (kegiatan.id == null) {
      return;
    }

    final setuju = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Kegiatan?'),
          content: Text(
            'Kegiatan "${kegiatan.judul}" '
            'akan dihapus permanen.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (setuju != true || !mounted) {
      return;
    }

    try {
      await DbHelper.hapus(kegiatan.id!);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kegiatan berhasil dihapus.',
          ),
        ),
      );
    } catch (error) {
      _tampilkanGalat(
        'Gagal menghapus kegiatan: $error',
      );
    }
  }

  void _tampilkanGalat(String pesan) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
      ),
    );
  }

  Future<void> _bukaForm([
    Kegiatan? kegiatan,
  ]) async {
    await Navigator.of(context).pushNamed<bool>(
      '/kegiatan',
      arguments: kegiatan,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabungKu'),
        actions: [
          IconButton(
            tooltip: 'Muat Ulang',
            onPressed: _muat,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaForm(),
        icon: const Icon(
          Icons.add,
        ),
        label: const Text('Kegiatan'),
      ),
      body: FutureBuilder<_DataHari>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal memuat data kegiatan.',
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _muat,
                      child: const Text(
                        'Coba Lagi',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              _muat();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                100,
              ),
              children: [
                Text(
                  formatTanggalPanjang(
                    DateTime.now(),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                RingkasanCard(
                  ringkasan: data.ringkasan,
                  target: widget.pengaturan.target,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Daftar Kegiatan',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Text(
                      '${data.kegiatan.length} kegiatan',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pencarianController,
                  onChanged: (nilai) {
                    _muat();
                  },
                  decoration: InputDecoration(
                    labelText: 'Cari kegiatan',
                    hintText: 'Nama atau kategori',
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon: _pencarianController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus Pencarian',
                            icon: const Icon(
                              Icons.close,
                            ),
                            onPressed: () {
                              _pencarianController.clear();
                              _muat();
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Tipe?>(
                  initialValue: _filterTipe,
                  decoration: const InputDecoration(
                    labelText: 'Filter Jenis Keuangan',
                    prefixIcon: Icon(
                      Icons.filter_list,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem<Tipe?>(
                      value: null,
                      child: Text('Semua Jenis'),
                    ),
                    DropdownMenuItem<Tipe?>(
                      value: Tipe.tanpa,
                      child: Text('Tanpa Uang'),
                    ),
                    DropdownMenuItem<Tipe?>(
                      value: Tipe.pemasukan,
                      child: Text('Pemasukan'),
                    ),
                    DropdownMenuItem<Tipe?>(
                      value: Tipe.pengeluaran,
                      child: Text('Pengeluaran'),
                    ),
                  ],
                  onChanged: (nilai) {
                    _filterTipe = nilai;
                    _muat();
                  },
                ),
                const SizedBox(height: 12),
                if (data.kegiatan.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_note_outlined,
                          size: 52,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _pencarianController.text.isNotEmpty ||
                                  _filterTipe != null
                              ? 'Tidak ada kegiatan yang cocok.'
                              : 'Belum ada kegiatan hari ini.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ...data.kegiatan.map((kegiatan) {
                    return KegiatanTile(
                      key: ValueKey(kegiatan.id),
                      kegiatan: kegiatan,
                      onCentang: (nilai) {
                        _centang(
                          kegiatan,
                          nilai,
                        );
                      },
                      onUbah: () {
                        _bukaForm(kegiatan);
                      },
                      onHapus: () {
                        _hapus(kegiatan);
                      },
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}
