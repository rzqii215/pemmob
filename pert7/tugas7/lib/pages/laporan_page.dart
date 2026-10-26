import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/ringkasan_card.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({
    super.key,
    required this.pengaturan,
  });

  final Pengaturan pengaturan;

  @override
  State<LaporanPage> createState() {
    return _LaporanPageState();
  }
}

class _DataLaporan {
  const _DataLaporan({
    required this.tanggal,
    required this.ringkasan,
    required this.perKategori,
    required this.tujuhHari,
  });

  final String tanggal;
  final Ringkasan ringkasan;
  final Map<String, int> perKategori;
  final List<LaporanHari> tujuhHari;
}

class _LaporanPageState extends State<LaporanPage> {
  DateTime _tanggal = DateTime.now();

  late Future<_DataLaporan> _future;

  @override
  void initState() {
    super.initState();

    _future = _ambil();

    versiData.addListener(_muat);
  }

  @override
  void dispose() {
    versiData.removeListener(_muat);

    super.dispose();
  }

  Future<_DataLaporan> _ambil() async {
    final tanggal = formatTanggalDatabase(
      _tanggal,
    );

    final ringkasan = await DbHelper.ringkasan(
      tanggal,
    );

    final perKategori = await DbHelper.pengeluaranPerKategori(
      tanggal,
    );

    final tujuhHari = await DbHelper.tujuhHari();

    return _DataLaporan(
      tanggal: tanggal,
      ringkasan: ringkasan,
      perKategori: perKategori,
      tujuhHari: tujuhHari,
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

  Future<void> _pilihTanggal() async {
    final terpilih = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (terpilih == null || !mounted) {
      return;
    }

    _tanggal = terpilih;
    _muat();
  }

  Future<void> _salinLaporan(
    _DataLaporan data,
  ) async {
    final teks = StringBuffer();

    teks.writeln('LAPORAN TABUNGKU');

    teks.writeln(
      formatTanggalPanjang(
        DateTime.parse(data.tanggal),
      ),
    );

    teks.writeln(
      'Kegiatan selesai: '
      '${data.ringkasan.selesai}/'
      '${data.ringkasan.jumlahKegiatan}',
    );

    teks.writeln(
      'Pemasukan: '
      '${formatRupiah(data.ringkasan.pemasukan)}',
    );

    teks.writeln(
      'Pengeluaran: '
      '${formatRupiah(data.ringkasan.pengeluaran)}',
    );

    teks.writeln(
      'Tabungan: '
      '${formatRupiah(data.ringkasan.tabungan)}',
    );

    teks.writeln(
      'Target: '
      '${formatRupiah(widget.pengaturan.target)}',
    );

    teks.writeln('');
    teks.writeln('PENGELUARAN PER KATEGORI');

    if (data.perKategori.isEmpty) {
      teks.writeln('Belum ada pengeluaran.');
    } else {
      for (final item in data.perKategori.entries) {
        teks.writeln(
          '${item.key}: '
          '${formatRupiah(item.value)}',
        );
      }
    }

    teks.writeln('');
    teks.writeln('TABUNGAN 7 HARI TERAKHIR');

    for (final hari in data.tujuhHari) {
      teks.writeln(
        '${hari.tanggal}: '
        '${formatRupiah(hari.tabungan)}',
      );
    }

    try {
      await Clipboard.setData(
        ClipboardData(
          text: teks.toString(),
        ),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Laporan berhasil disalin.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyalin laporan: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
      ),
      body: FutureBuilder<_DataLaporan>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Laporan gagal dimuat.',
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
                24,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pilihTanggal,
                        icon: const Icon(
                          Icons.calendar_month,
                        ),
                        label: Text(
                          formatTanggal(
                            _tanggal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: () {
                        _salinLaporan(data);
                      },
                      tooltip: 'Salin Laporan',
                      icon: const Icon(
                        Icons.copy_all_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                RingkasanCard(
                  ringkasan: data.ringkasan,
                  target: widget.pengaturan.target,
                  judul: 'Ringkasan Tanggal Dipilih',
                ),
                const SizedBox(height: 24),
                Text(
                  'Pengeluaran per Kategori',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  child: data.perKategori.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(18),
                          child: Text(
                            'Belum ada pengeluaran '
                            'pada tanggal ini.',
                          ),
                        )
                      : Column(
                          children: data.perKategori.entries.map((item) {
                            return ListTile(
                              leading: const Icon(
                                Icons.category_outlined,
                              ),
                              title: Text(item.key),
                              trailing: Text(
                                formatRupiah(item.value),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 24),
                Text(
                  '7 Hari Terakhir',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ringkasan tabungan bersih '
                  'setiap tanggal.',
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  child: Column(
                    children: data.tujuhHari.map((hari) {
                      final negatif = hari.tabungan < 0;

                      return ListTile(
                        title: Text(
                          formatTanggalSingkat(
                            hari.tanggal,
                          ),
                        ),
                        subtitle: Text(
                          'Masuk '
                          '${formatRupiah(hari.pemasukan)} '
                          '• Keluar '
                          '${formatRupiah(hari.pengeluaran)}',
                          maxLines: 2,
                        ),
                        trailing: Text(
                          formatRupiah(
                            hari.tabungan,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: negatif
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
