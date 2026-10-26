import 'package:flutter/material.dart';

import '../models/kegiatan.dart';
import '../utils/format.dart';

class RingkasanCard extends StatelessWidget {
  const RingkasanCard({
    super.key,
    required this.ringkasan,
    required this.target,
    this.judul = 'Ringkasan Hari Ini',
  });

  final Ringkasan ringkasan;
  final int target;
  final String judul;

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final tabungan = ringkasan.tabungan;

    final double capaian = target <= 0
        ? (tabungan >= 0 ? 1.0 : 0.0)
        : (tabungan / target).clamp(0.0, 1.0).toDouble();

    final bool tercapai = tabungan >= target;
    final bool negatif = tabungan < 0;

    return Card(
      elevation: 0,
      color: warna.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: warna.onPrimaryContainer,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              formatRupiah(tabungan),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: negatif ? Colors.red : warna.onPrimaryContainer,
                  ),
            ),
            Text(
              'Tabungan Bersih',
              style: TextStyle(
                color: warna.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _NilaiRingkasan(
                    label: 'Pemasukan',
                    nilai: formatRupiah(
                      ringkasan.pemasukan,
                    ),
                    warna: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NilaiRingkasan(
                    label: 'Pengeluaran',
                    nilai: formatRupiah(
                      ringkasan.pengeluaran,
                    ),
                    warna: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Kegiatan selesai '
              '${ringkasan.selesai}/'
              '${ringkasan.jumlahKegiatan}',
              style: TextStyle(
                color: warna.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Target Tabungan',
                  style: TextStyle(
                    color: warna.onPrimaryContainer,
                  ),
                ),
                Text(
                  formatRupiah(target),
                  style: TextStyle(
                    color: warna.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: capaian,
              ),
              duration: const Duration(
                milliseconds: 600,
              ),
              builder: (context, nilai, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: nilai,
                    minHeight: 10,
                    backgroundColor: warna.surface,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  negatif
                      ? Icons.warning_amber_rounded
                      : tercapai
                          ? Icons.celebration_outlined
                          : Icons.flag_outlined,
                  size: 18,
                  color: negatif ? Colors.red : warna.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    negatif
                        ? 'Peringatan: pengeluaran melebihi pemasukan.'
                        : tercapai
                            ? 'Bagus! Target menabung tercapai.'
                            : 'Terus menabung untuk mencapai target.',
                    style: TextStyle(
                      color: negatif ? Colors.red : warna.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NilaiRingkasan extends StatelessWidget {
  const _NilaiRingkasan({
    required this.label,
    required this.nilai,
    required this.warna,
  });

  final String label;
  final String nilai;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            nilai,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: warna,
            ),
          ),
        ),
      ],
    );
  }
}
