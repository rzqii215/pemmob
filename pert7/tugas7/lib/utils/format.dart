const List<String> _namaBulan = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const List<String> _namaHari = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

String formatTanggalDatabase(DateTime tanggal) {
  final tahun = tanggal.year.toString().padLeft(4, '0');
  final bulan = tanggal.month.toString().padLeft(2, '0');
  final hari = tanggal.day.toString().padLeft(2, '0');

  return '$tahun-$bulan-$hari';
}

String formatTanggal(DateTime tanggal) {
  return '${tanggal.day} '
      '${_namaBulan[tanggal.month - 1]} '
      '${tanggal.year}';
}

String formatTanggalPanjang(DateTime tanggal) {
  return '${_namaHari[tanggal.weekday - 1]}, '
      '${formatTanggal(tanggal)}';
}

String formatTanggalSingkat(String tanggalDatabase) {
  final tanggal = DateTime.parse(tanggalDatabase);
  final bulan = _namaBulan[tanggal.month - 1];

  return '${tanggal.day} ${bulan.substring(0, 3)}';
}

String formatRupiah(int nominal) {
  final negatif = nominal < 0;
  final digit = nominal.abs().toString();
  final hasil = StringBuffer();

  for (int index = 0; index < digit.length; index++) {
    final sisaDigit = digit.length - index;

    hasil.write(digit[index]);

    if (sisaDigit > 1 && sisaDigit % 3 == 1) {
      hasil.write('.');
    }
  }

  return '${negatif ? '-' : ''}Rp $hasil';
}
