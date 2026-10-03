# Praktikum Flutter Fundamental — Pertemuan 2

> **Mata Kuliah:** Pemrograman Mobile  
> **Praktikum:** Flutter Fundamental  
> **Pertemuan:** 2  
> **Nama:** Muhamad Rizqi Candra  
> **NIM:** 20240801035  
> **Prodi:** Teknik Informatika  

---

## 1. Tujuan Praktikum

Pada Pertemuan 2 ini, materi yang dipelajari berfokus pada penggunaan layout, pembuatan daftar data, serta perpindahan antar halaman pada Flutter.

Tujuan praktikum ini adalah:

- Memahami penggunaan `Container`, `Padding`, `Row`, `Column`, dan `Expanded`.
- Membuat daftar data menggunakan `ListView.builder`.
- Menggunakan `Card` dan `ListTile` untuk membuat tampilan daftar.
- Memahami penggunaan class sederhana sebagai model data pada Dart.
- Memahami navigasi antar halaman menggunakan `Navigator.push()` dan `Navigator.pop()`.
- Mengirim data dari halaman daftar ke halaman detail.

---

## 2. Persiapan Project

Project dibuat menggunakan Flutter dengan perintah:

```bash
flutter create praktikum_2
```

Setelah project dibuat, proses pengerjaan dilakukan terutama pada file:

```text
lib/main.dart
```

Untuk menjalankan aplikasi digunakan:

```bash
flutter run
```

Project kemudian dijalankan menggunakan emulator/device yang sudah terhubung dengan Flutter.

---

# 3. Materi yang Dipelajari

## 3.1 Container

`Container` digunakan untuk membuat sebuah area atau kotak yang dapat diberi padding, margin, warna, ukuran, dan dekorasi.

Contoh penggunaan:

```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.blue.shade50,
    borderRadius: BorderRadius.circular(12),
  ),
  child: ...
)
```

Pada praktikum, `Container` digunakan untuk membuat area kartu profil dan pada salah satu latihan digunakan sebagai pengganti `Card`.

---

## 3.2 Padding

`Padding` digunakan untuk memberikan jarak antara isi widget dengan batas area widget tersebut.

Contoh:

```dart
Padding(
  padding: const EdgeInsets.all(16),
  child: ...
)
```

Pada bagian profil, `Padding` digunakan supaya tampilan tidak terlalu menempel dengan sisi layar.

---

## 3.3 Row dan Column

`Row` digunakan untuk menyusun widget secara horizontal, sedangkan `Column` digunakan untuk menyusun widget secara vertikal.

Contoh:

```dart
Row(
  children: [
    const CircleAvatar(),
    const SizedBox(width: 16),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Rizqi'),
          Text('20240801035'),
        ],
      ),
    ),
  ],
)
```

Pada contoh tersebut, `Row` digunakan untuk menempatkan avatar di sebelah informasi pengguna. Kemudian `Column` digunakan untuk menampilkan nama dan NIM secara vertikal.

---

## 3.4 Expanded

`Expanded` digunakan agar widget dapat menggunakan ruang yang tersedia di dalam `Row` atau `Column`.

Pada bagian profil, `Expanded` digunakan agar bagian informasi pengguna dapat menyesuaikan ruang yang tersedia dan mengurangi kemungkinan terjadinya overflow.

```dart
Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text('Rizqi'),
      Text('20240801035'),
    ],
  ),
)
```

---

## 3.5 ListView.builder

`ListView.builder` digunakan untuk membuat daftar yang dapat di-scroll.

Contoh:

```dart
ListView.builder(
  itemCount: daftarMenu.length,
  itemBuilder: (context, index) {
    final item = daftarMenu[index];

    return ListTile(
      title: Text(item.nama),
    );
  },
)
```

Keuntungan penggunaan `ListView.builder` adalah item dibuat berdasarkan data yang ada sehingga lebih praktis ketika jumlah data bertambah.

---

## 3.6 Card dan ListTile

`Card` digunakan untuk memberikan tampilan seperti kartu pada setiap item daftar.

Sementara itu, `ListTile` menyediakan struktur sederhana yang dapat berisi:

- `leading`
- `title`
- `subtitle`
- `trailing`
- `onTap`

Contoh yang digunakan:

```dart
Card(
  child: ListTile(
    leading: const Icon(Icons.restaurant),
    title: Text(item.nama),
    subtitle: Text('Rp ${item.harga}'),
    trailing: const Icon(Icons.chevron_right),
  ),
)
```

---

## 3.7 Class sebagai Model Data

Pada praktikum dibuat class `Makanan` untuk menyimpan data makanan.

```dart
class Makanan {
  final String nama;
  final int harga;

  const Makanan(this.nama, this.harga);
}
```

Dengan menggunakan class, data menjadi lebih terstruktur karena setiap objek `Makanan` mempunyai nama dan harga.

Contoh data:

```dart
const daftarMenu = [
  Makanan('Nasi Goreng', 15000),
  Makanan('Mie Ayam', 12000),
  Makanan('Es Teh', 4000),
  Makanan('Ayam Bakar', 20000),
];
```

---

## 3.8 Navigator

`Navigator` digunakan untuk berpindah antar halaman.

Untuk membuka halaman baru digunakan:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => DetailPage(
      makanan: item,
    ),
  ),
);
```

Sedangkan untuk kembali ke halaman sebelumnya:

```dart
Navigator.pop(context);
```

Pada praktikum, data makanan juga dikirim dari halaman menu ke halaman detail melalui parameter constructor.

---

# 4. Praktikum Bagian A — Membuat Profil

Bagian pertama digunakan untuk memahami dasar layout Flutter.

Tampilan terdiri dari:

- `Padding`
- `Container`
- `Row`
- `CircleAvatar`
- `Expanded`
- `Column`
- `Text`

Kode yang digunakan:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 2',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 32,
                child: Icon(
                  Icons.person,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Rizqi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('20240801035'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Hasil yang Dipahami

Pada bagian ini saya memahami bagaimana beberapa widget dasar Flutter dapat digabungkan untuk membuat satu tampilan. `Row` digunakan untuk posisi horizontal, sedangkan `Column` digunakan untuk menyusun teks secara vertikal.

---

# 5. Praktikum Bagian B — Daftar Menu

Setelah memahami layout, praktikum dilanjutkan dengan membuat daftar menu makanan.

Model datanya:

```dart
class Makanan {
  final String nama;
  final int harga;

  const Makanan(this.nama, this.harga);
}
```

Data awal:

```dart
const daftarMenu = [
  Makanan('Nasi Goreng', 15000),
  Makanan('Mie Ayam', 12000),
  Makanan('Es Teh', 4000),
  Makanan('Ayam Bakar', 20000),
];
```

Data tersebut kemudian ditampilkan menggunakan `ListView.builder`.

```dart
body: ListView.builder(
  itemCount: daftarMenu.length,
  itemBuilder: (context, index) {
    final item = daftarMenu[index];

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: const Icon(Icons.restaurant),
        title: Text(item.nama),
        subtitle: Text('Rp ${item.harga}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  },
),
```

Dari bagian ini saya memahami bahwa data tidak perlu ditulis satu per satu pada widget. Data cukup disimpan dalam list kemudian ditampilkan menggunakan `ListView.builder`.

---

# 6. Praktikum Bagian C — Navigasi ke Detail

Pada bagian ini setiap item menu dapat ditekan untuk membuka halaman detail.

Kode navigasinya:

```dart
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DetailPage(
        makanan: item,
      ),
    ),
  );
},
```

Halaman detail menerima data makanan:

```dart
class DetailPage extends StatelessWidget {
  final Makanan makanan;

  const DetailPage({
    super.key,
    required this.makanan,
  });
```

Kemudian informasi makanan ditampilkan:

```dart
Text(
  makanan.nama,
  style: const TextStyle(
    fontSize: 24,
  ),
),
Text('Rp ${makanan.harga}'),
```

Untuk kembali ke halaman daftar:

```dart
ElevatedButton(
  onPressed: () => Navigator.pop(context),
  child: const Text('Kembali'),
)
```

### Alur Navigasi

```text
Daftar Menu
    |
    | tekan salah satu menu
    v
Halaman Detail
    |
    | tekan tombol Kembali
    v
Daftar Menu
```

Hal ini menunjukkan bahwa data `item` dari halaman daftar dapat dikirim ke halaman detail melalui constructor.

---

# 7. Latihan 1 — Menambahkan Menu

Pada latihan pertama, saya menambahkan tiga menu baru:

```text
Bakso          Rp 19.000
Bebek Goreng   Rp 15.000
Es Teler       Rp 9.000
```

Sehingga jumlah menu menjadi tujuh:

```dart
const daftarMenu = [
  Makanan('Nasi Goreng', 15000),
  Makanan('Mie Ayam', 12000),
  Makanan('Es Teh', 4000),
  Makanan('Ayam Bakar', 20000),
  Makanan('Bakso', 19000),
  Makanan('Bebek Goreng', 15000),
  Makanan('Es Teler', 9000),
];
```

Karena menggunakan `ListView.builder`, tambahan data tersebut otomatis dapat ditampilkan dan daftar tetap bisa di-scroll.

---

# 8. Latihan 2 — Menambahkan Deskripsi

Pada latihan kedua, class `Makanan` dikembangkan dengan menambahkan properti `deskripsi`.

```dart
class Makanan {
  final String nama;
  final int harga;
  final String deskripsi;

  const Makanan(
    this.nama,
    this.harga,
    this.deskripsi,
  );
}
```

Contoh data:

```dart
Makanan(
  'Nasi Goreng',
  15000,
  'Nasi goreng dengan bumbu racikan.',
),
```

Deskripsi kemudian ditampilkan pada halaman detail:

```dart
Text(makanan.deskripsi),
```

Dengan penambahan ini, halaman detail tidak hanya menampilkan nama dan harga, tetapi juga informasi tambahan mengenai menu.

---

# 9. Latihan 3 — Mengganti Card dengan Container

Pada latihan ketiga, `Card` diganti menggunakan `Container`.

```dart
Container(
  margin: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  decoration: BoxDecoration(
    color: Colors.brown.shade50,
    borderRadius: BorderRadius.circular(12),
  ),
  child: ListTile(
    leading: const Icon(Icons.restaurant),
    title: Text(item.nama),
    subtitle: Text('Rp ${item.harga}'),
    trailing: const Icon(Icons.chevron_right),
  ),
)
```

Penggantian ini membuat saya lebih memahami bahwa tampilan sebuah komponen tidak selalu harus menggunakan `Card`. `Container` juga dapat digunakan dengan `BoxDecoration` untuk mengatur warna dan bentuk sudut.

Pada latihan ini warna tema juga diubah menjadi:

```dart
colorSchemeSeed: Colors.brown,
```

---

# 10. Latihan 4 — Format Harga

Pada latihan keempat, harga yang sebelumnya ditampilkan seperti:

```text
Rp 15000
```

diubah menjadi:

```text
Rp 15.000
```

Untuk melakukan format tersebut dibuat fungsi:

```dart
String formatHarga(int harga) {
  String angka = harga.toString();
  String hasil = '';

  int hitung = 0;

  for (int i = angka.length - 1; i >= 0; i--) {
    hasil = angka[i] + hasil;
    hitung++;

    if (hitung == 3 && i != 0) {
      hasil = '.$hasil';
      hitung = 0;
    }
  }

  return hasil;
}
```

Kemudian digunakan pada daftar:

```dart
subtitle: Text('Rp ${formatHarga(item.harga)}'),
```

dan pada halaman detail:

```dart
Text('Rp ${formatHarga(makanan.harga)}'),
```

### Hasil Format

| Harga Data | Tampilan |
|---:|---:|
| 15000 | Rp 15.000 |
| 12000 | Rp 12.000 |
| 4000 | Rp 4.000 |
| 20000 | Rp 20.000 |
| 19000 | Rp 19.000 |
| 15000 | Rp 15.000 |
| 9000 | Rp 9.000 |

---

# 11. Tugas — Aplikasi Daftar Kontak

Setelah menyelesaikan latihan, tugas praktikum adalah membuat aplikasi **Daftar Kontak**.

Ketentuan tugas yang diterapkan:

- Minimal enam kontak.
- Setiap kontak mempunyai nama, nomor telepon, dan email.
- Data disimpan menggunakan list dari object class.
- Data ditampilkan menggunakan `ListView.builder`.
- Setiap kontak memiliki avatar dengan huruf pertama dari nama.
- Ketika kontak ditekan, aplikasi membuka halaman detail.
- Halaman detail menampilkan seluruh data kontak.
- Tersedia tombol untuk kembali ke halaman sebelumnya.

---

# 12. Membuat Model Kontak

Untuk menyimpan data kontak dibuat class `Kontak`:

```dart
class Kontak {
  final String nama;
  final String telepon;
  final String email;

  const Kontak(
    this.nama,
    this.telepon,
    this.email,
  );
}
```

Dengan model tersebut, satu object kontak mempunyai tiga informasi utama:

```text
Nama
Nomor Telepon
Email
```

---

# 13. Data Kontak

Data yang digunakan berjumlah enam kontak:

```dart
const daftarKontak = [
  Kontak(
    'wowo',
    '0813623926',
    'wowo@gmail.com',
  ),
  Kontak(
    'hendra',
    '085127394',
    'hendra@gmail.com',
  ),
  Kontak(
    'aul',
    '0897652417',
    'aul@gmail.com',
  ),
  Kontak(
    'christine',
    '08823711649',
    'christine@gmail.com',
  ),
  Kontak(
    'silvia',
    '089153725',
    'silvia@gmail.com',
  ),
  Kontak(
    'nabil',
    '081725392',
    'nabil@gmail.com',
  ),
];
```

---

# 14. Menampilkan Daftar Kontak

Daftar kontak ditampilkan menggunakan `ListView.builder`.

```dart
body: ListView.builder(
  itemCount: daftarKontak.length,
  itemBuilder: (context, index) {
    final kontak = daftarKontak[index];

    return ListTile(
      leading: CircleAvatar(
        child: Text(kontak.nama[0]),
      ),
      title: Text(kontak.nama),
      subtitle: Text(kontak.telepon),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailKontakPage(
              kontak: kontak,
            ),
          ),
        );
      },
    );
  },
),
```

Pada bagian `CircleAvatar`, karakter pertama nama diambil menggunakan:

```dart
kontak.nama[0]
```

Contohnya, kontak `wowo` akan mendapatkan avatar dengan huruf:

```text
w
```

---

# 15. Halaman Detail Kontak

Ketika salah satu kontak ditekan, aplikasi berpindah ke `DetailKontakPage`.

```dart
class DetailKontakPage extends StatelessWidget {
  final Kontak kontak;

  const DetailKontakPage({
    super.key,
    required this.kontak,
  });
```

Data kontak kemudian ditampilkan:

```dart
Text(
  kontak.nama,
  style: const TextStyle(
    fontSize: 24,
  ),
),
const SizedBox(height: 8),
Text(kontak.telepon),
const SizedBox(height: 8),
Text(kontak.email),
```

Tombol kembali menggunakan:

```dart
ElevatedButton(
  onPressed: () => Navigator.pop(context),
  child: const Text('Kembali'),
)
```

---

# 16. Alur Kerja Aplikasi Daftar Kontak

Alur aplikasi yang dibuat dapat digambarkan seperti berikut:

```text
                    Aplikasi Dibuka
                          |
                          v
                  Halaman Daftar Kontak
                          |
              +-----------+-----------+
              |                       |
        Pilih Kontak             Scroll Daftar
              |
              v
          Detail Kontak
              |
       +------+------+
       |             |
  Lihat Data      Kembali
                     |
                     v
             Daftar Kontak
```

Data tidak dibuat langsung di dalam widget satu per satu. Data disimpan terlebih dahulu dalam bentuk object `Kontak`, kemudian dibaca oleh `ListView.builder`.

---

# 17. Pemahaman Teknis

## 17.1 Hubungan Model dan UI

Pada aplikasi ini, class `Kontak` berfungsi sebagai model data.

```dart
class Kontak {
  final String nama;
  final String telepon;
  final String email;
}
```

Sedangkan `KontakPage` bertugas menampilkan data tersebut.

Jadi secara sederhana:

```text
Class Kontak
      |
      v
daftarKontak
      |
      v
ListView.builder
      |
      v
ListTile
```

Dengan pola ini, tampilan aplikasi menjadi lebih mudah dikelola karena data dan tampilan mempunyai fungsi yang berbeda.

---

## 17.2 Cara Kerja ListView.builder

`ListView.builder` menerima jumlah item melalui:

```dart
itemCount: daftarKontak.length
```

Kemudian setiap posisi data diproses melalui:

```dart
itemBuilder: (context, index)
```

Data pada posisi tertentu diambil menggunakan:

```dart
final kontak = daftarKontak[index];
```

Setelah itu object tersebut digunakan untuk membuat tampilan `ListTile`.

---

## 17.3 Cara Kerja Navigator

Saat user memilih kontak:

```dart
Navigator.push(...)
```

akan membuka halaman baru.

Data kontak dikirim melalui:

```dart
DetailKontakPage(
  kontak: kontak,
)
```

Kemudian halaman detail menerima data tersebut melalui:

```dart
final Kontak kontak;
```

Ketika user menekan tombol kembali:

```dart
Navigator.pop(context)
```

halaman detail ditutup dan user kembali ke halaman daftar.

---

# 18. Konsep yang Saya Pahami dari Praktikum

Dari praktikum ini, beberapa konsep yang saya pahami adalah:

### Layout

Flutter menyusun tampilan menggunakan widget. `Row` dan `Column` digunakan untuk menentukan arah penyusunan widget, sedangkan `Container` dan `Padding` membantu mengatur tampilan dan jarak.

### Data

Data dapat dibuat menggunakan class sehingga lebih terstruktur. Object dari class tersebut kemudian dapat disimpan di dalam list.

### List

`ListView.builder` cocok digunakan ketika data berasal dari sebuah list karena item dapat dibuat berdasarkan isi data.

### Navigasi

`Navigator.push()` digunakan untuk berpindah ke halaman baru, sedangkan `Navigator.pop()` digunakan untuk kembali.

### Passing Data

Data dapat dikirim ke halaman berikutnya melalui constructor. Pada tugas ini, object `Kontak` dikirim dari halaman daftar ke halaman detail.

---

# 19. Beberapa Hal Teknis yang Diperhatikan

## Overflow pada Row

Jika isi `Row` terlalu panjang, widget dapat mengalami overflow. Salah satu cara mengatasinya adalah menggunakan `Expanded`.

Contoh:

```dart
Expanded(
  child: Column(
    children: [
      ...
    ],
  ),
)
```

## ListView di dalam Column

Jika `ListView` ditempatkan di dalam `Column`, perlu memperhatikan ukuran ruang yang tersedia. Pada kondisi tertentu `Expanded` dapat digunakan agar `ListView` mendapatkan ruang yang sesuai.

## Navigator dan Context

`Navigator` menggunakan `BuildContext` untuk mengetahui posisi halaman yang sedang aktif. Oleh karena itu `context` pada `onTap` digunakan saat menjalankan:

```dart
Navigator.push(
  context,
  ...
)
```

---

# 20. Hasil Akhir Praktikum

Pada akhir praktikum berhasil dibuat aplikasi Daftar Kontak sederhana dengan fitur:

- Menampilkan enam kontak.
- Menampilkan avatar berdasarkan huruf pertama nama.
- Menampilkan nama dan nomor telepon pada halaman utama.
- Menampilkan detail nama, nomor telepon, dan email.
- Navigasi dari halaman daftar ke halaman detail.
- Tombol kembali ke halaman daftar.
- Data menggunakan class `Kontak`.
- Daftar data menggunakan `ListView.builder`.

Aplikasi ini merupakan pengembangan dari materi sebelumnya tentang layout dan kemudian dilanjutkan dengan penggunaan list, model data, serta navigasi.

---

# 21. Kesimpulan

Praktikum Flutter Fundamental Pertemuan 2 memberikan pemahaman mengenai bagaimana membuat tampilan yang lebih terstruktur menggunakan widget layout, kemudian mengolah sekumpulan data menggunakan `ListView.builder`.

Selain membuat tampilan daftar, saya juga memahami penggunaan class sebagai model sederhana untuk menyimpan data. Data tersebut kemudian dapat dikirim dari satu halaman ke halaman lain menggunakan constructor dan navigasi `Navigator`.

Dari seluruh latihan, konsep yang paling terlihat hubungannya adalah antara **model data, list, widget tampilan, dan navigasi**. Data yang disimpan dalam object dapat ditampilkan pada halaman utama, kemudian object yang sama dapat dikirim ke halaman detail ketika item dipilih.

Dengan demikian, aplikasi yang dibuat tidak hanya menampilkan tampilan statis, tetapi sudah memiliki alur interaksi sederhana antara halaman daftar dan halaman detail.

---

# 22. Struktur Konsep Project

Secara sederhana, struktur logika aplikasi yang dibuat adalah:

```text
main.dart
│
├── MyApp
│
├── Model
│   ├── Makanan
│   └── Kontak
│
├── Data
│   ├── daftarMenu
│   └── daftarKontak
│
├── Halaman Menu
│   └── MenuPage
│
├── Halaman Detail Menu
│   └── DetailPage
│
├── Halaman Kontak
│   └── KontakPage
│
└── Halaman Detail Kontak
    └── DetailKontakPage
```

---

# 23. Referensi

Materi praktikum mengacu pada konsep Flutter Fundamental mengenai:

- Flutter Layout
- Container
- Padding
- Row dan Column
- Expanded
- ListView
- ListView.builder
- Card
- ListTile
- Navigator
- Passing data antar halaman

Referensi utama juga mengikuti materi yang terdapat pada modul praktikum **Flutter Fundamental — Pertemuan 2: Layout, ListView, dan Navigasi Antar Halaman**.

---

> **Catatan:** README ini dibuat sebagai dokumentasi proses praktikum mulai dari pemahaman materi, implementasi kode, latihan, sampai tugas akhir Daftar Kontak.
