import 'package:flutter/material.dart';

import '../models/kegiatan.dart';
import '../utils/format.dart';

class KegiatanTile extends StatelessWidget {
  const KegiatanTile({
    super.key,
    required this.kegiatan,
    required this.onCentang,
    required this.onUbah,
    required this.onHapus,
  });

  final Kegiatan kegiatan;
  final ValueChanged<bool> onCentang;
  final VoidCallback onUbah;
  final VoidCallback onHapus;

  @override
  Widget build(BuildContext context) {
    final String nilai;

    switch (kegiatan.tipe) {
      case Tipe.pemasukan:
        nilai = '+${formatRupiah(kegiatan.nominal)}';
        break;
      case Tipe.pengeluaran:
        nilai = '-${formatRupiah(kegiatan.nominal)}';
        break;
      case Tipe.tanpa:
        nilai = 'Tanpa uang';
        break;
    }

    final Color warna;

    switch (kegiatan.tipe) {
      case Tipe.pemasukan:
        warna = Colors.green.shade700;
        break;
      case Tipe.pengeluaran:
        warna = Colors.red.shade700;
        break;
      case Tipe.tanpa:
        warna = Theme.of(
          context,
        ).colorScheme.onSurfaceVariant;
        break;
    }

    return Card(
      elevation: 0,
      child: ListTile(
        leading: Checkbox(
          value: kegiatan.selesai,
          onChanged: (nilai) {
            onCentang(nilai ?? false);
          },
        ),
        title: Text(
          kegiatan.judul,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: kegiatan.selesai ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kegiatan.tipe == Tipe.pengeluaran
                  ? 'Pengeluaran • ${kegiatan.kategori}'
                  : kegiatan.tipe == Tipe.pemasukan
                      ? 'Pemasukan'
                      : 'Tidak melibatkan uang',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              nilai,
              style: TextStyle(
                color: warna,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          tooltip: 'Opsi kegiatan',
          onSelected: (aksi) {
            if (aksi == 'ubah') {
              onUbah();
            } else if (aksi == 'hapus') {
              onHapus();
            }
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: 'ubah',
                child: Text('Ubah'),
              ),
              PopupMenuItem(
                value: 'hapus',
                child: Text('Hapus'),
              ),
            ];
          },
        ),
      ),
    );
  }
}
