import 'package:flutter/material.dart';

import '../state/pengaturan.dart';
import '../utils/format.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({
    super.key,
    required this.pengaturan,
  });

  final Pengaturan pengaturan;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pengaturan,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Pengaturan'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Preferensi Aplikasi',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      title: const Text(
                        'Mode Gelap',
                      ),
                      subtitle: const Text(
                        'Gunakan tampilan '
                        'dengan latar gelap',
                      ),
                      secondary: const Icon(
                        Icons.dark_mode_outlined,
                      ),
                      value: pengaturan.modeGelap,
                      onChanged: (nilai) {
                        pengaturan.aturModeGelap(nilai);
                      },
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Warna Tema',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: Pengaturan.pilihanWarna.map((warna) {
                              return ChoiceChip(
                                label: Text(warna),
                                selected: pengaturan.warna == warna,
                                onSelected: (terpilih) {
                                  if (terpilih) {
                                    pengaturan.aturWarna(
                                      warna,
                                    );
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Target Menabung',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    20,
                    16,
                    16,
                  ),
                  child: Column(
                    children: [
                      Text(
                        formatRupiah(
                          pengaturan.target,
                        ),
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Target tabungan per hari',
                      ),
                      const SizedBox(height: 16),
                      Slider(
                        min: 5000,
                        max: 100000,
                        divisions: 19,
                        value: pengaturan.target.clamp(5000, 100000).toDouble(),
                        label: formatRupiah(
                          pengaturan.target,
                        ),
                        onChanged: (nilai) {
                          pengaturan.aturTarget(
                            nilai.round(),
                          );
                        },
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rp 5.000'),
                          Text('Rp 100.000'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Pengaturan disimpan otomatis '
                        'dan tetap tersedia setelah '
                        'aplikasi ditutup.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                child: const ListTile(
                  leading: Icon(
                    Icons.info_outline,
                  ),
                  title: Text(
                    'Tentang TabungKu',
                  ),
                  subtitle: Text(
                    'Mini proyek Flutter Fundamental '
                    'Pertemuan 7.\n'
                    'To-Do List dan Manajemen Keuangan.',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
