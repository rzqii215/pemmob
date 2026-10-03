# Praktikum Flutter Fundamental — Pertemuan 1

> **Mata Kuliah:** Pemrograman Mobile  
> **Praktikum:** Flutter Fundamental  
> **Pertemuan:** 1  
> **Nama:** Muhamad Rizqi Candra
> **NIM:** 20240801035  
> **Prodi:** Teknik Informatika

---

## 1. Tentang Praktikum

Praktikum pertama ini membahas dasar-dasar Flutter sebelum masuk ke pembuatan aplikasi yang lebih kompleks. Fokus utamanya adalah mengenal Flutter dan Dart, menyiapkan environment, membuat project pertama, memahami struktur project, mengenal widget, sampai membuat aplikasi sederhana yang mempunyai state.

Di modul, praktikum dibagi menjadi beberapa bagian mulai dari instalasi dan verifikasi sampai tugas membuat **Kartu Perkenalan**.

Tujuan yang saya pahami dari praktikum ini bukan hanya supaya aplikasi bisa dijalankan, tetapi juga supaya saya mulai terbiasa dengan cara kerja Flutter, terutama konsep **widget**, **StatelessWidget**, **StatefulWidget**, dan **setState()**.

---

## 2. Tujuan Pembelajaran

Berdasarkan modul, setelah menyelesaikan praktikum ini mahasiswa diharapkan mampu:

- Menjelaskan Flutter dan Dart serta perbedaannya dengan pengembangan native.
- Memasang Flutter SDK, editor, emulator atau perangkat fisik.
- Membuat dan menjalankan project Flutter pertama.
- Memahami struktur folder project Flutter.
- Memahami konsep dasar widget.
- Memodifikasi UI sederhana.
- Menggunakan fitur **hot reload** ketika melakukan perubahan kode.

---

## 3. Tools dan Environment

Tools yang digunakan pada praktikum:

- Flutter SDK versi stabil.
- Dart sebagai bahasa pemrograman.
- Android Studio atau VS Code.
- Android SDK.
- Android Emulator atau perangkat Android.
- Koneksi internet.

Sebelum mulai membuat aplikasi, environment harus dipastikan sudah terbaca dengan baik oleh Flutter.

Perintah yang digunakan:

```bash
flutter doctor
```

Jika ada masalah pada lisensi Android, perintah yang digunakan dari modul adalah:

```bash
flutter doctor --android-licenses
```

Setelah proses setup selesai, targetnya adalah Flutter, Android toolchain, dan editor sudah terdeteksi dengan baik.

---

## 4. Membuat Project Flutter

Project pertama dibuat menggunakan perintah:

```bash
flutter create praktikum_1
```

Kemudian masuk ke folder project:

```bash
cd praktikum_1
```

Untuk menjalankan aplikasi:

```bash
flutter run
```

Setelah berhasil dijalankan, Flutter akan menampilkan aplikasi counter bawaan. Dari sini saya mulai melihat bahwa Flutter sudah menyediakan struktur aplikasi dasar yang bisa langsung dijalankan dan dimodifikasi.

---

## 5. Struktur Project yang Dipelajari

Beberapa bagian project yang saya pahami dari modul:

| File / Folder | Fungsi |
|---|---|
| `lib/main.dart` | Titik masuk aplikasi dan tempat kode utama dibuat |
| `pubspec.yaml` | Konfigurasi project, dependency, dan asset |
| `android/` | Bagian project untuk platform Android |
| `ios/` | Bagian project untuk platform iOS |
| `test/` | Tempat file pengujian |

Untuk praktikum ini, file yang paling sering digunakan adalah:

```text
lib/main.dart
```

Karena seluruh implementasi yang dibuat pada praktikum ini masih berupa aplikasi sederhana dalam satu file.

---

# 6. Pemahaman Dasar Flutter

## 6.1 Flutter

Flutter adalah UI toolkit yang digunakan untuk membuat aplikasi dengan satu basis kode. Pada praktikum ini, Flutter digunakan untuk membuat aplikasi mobile sederhana.

Yang cukup penting untuk dipahami dari awal adalah bahwa tampilan Flutter dibangun menggunakan **widget**.

Contohnya:

```dart
Text()
Icon()
Column()
SizedBox()
Scaffold()
AppBar()
```

Masing-masing widget mempunyai fungsi sendiri dan bisa disusun menjadi satu tampilan.

---

## 6.2 Dart

Dart adalah bahasa pemrograman yang digunakan dalam Flutter.

Contoh sederhana:

```dart
int _count = 0;
```

Kode tersebut digunakan untuk membuat variabel integer yang nantinya dipakai sebagai nilai counter.

---

## 6.3 Widget

Konsep widget merupakan salah satu bagian yang paling penting pada praktikum ini.

Pada aplikasi yang dibuat, struktur sederhananya dapat dibayangkan seperti:

```text
MaterialApp
└── Scaffold
    ├── AppBar
    └── Center
        └── Column
            ├── Icon
            ├── SizedBox
            ├── Text
            └── Text
```

Struktur tersebut biasa disebut sebagai **widget tree**.

Jadi, tampilan aplikasi tidak dibuat seperti HTML biasa, tetapi disusun dari widget yang berada di dalam widget lainnya.

---

# 7. StatelessWidget dan StatefulWidget

## StatelessWidget

`StatelessWidget` digunakan ketika tampilan widget tidak mempunyai state yang berubah.

Pada project ini, `MyApp` dibuat sebagai `StatelessWidget`:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Praktikum 1',
      home: CounterPage(),
    );
  }
}
```

`MyApp` bertugas sebagai bagian awal aplikasi dan menentukan halaman yang akan ditampilkan.

---

## StatefulWidget

Berbeda dengan `StatelessWidget`, `StatefulWidget` digunakan ketika terdapat data atau tampilan yang bisa berubah.

Pada praktikum ini digunakan untuk membuat counter:

```dart
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}
```

State-nya kemudian dibuat di:

```dart
class _CounterPageState extends State<CounterPage> {
  int _count = 0;
}
```

Variabel `_count` merupakan state yang berubah ketika tombol ditekan.

---

# 8. Bagian D — Hello Flutter

Pada bagian ini, `main.dart` diubah menjadi aplikasi sederhana yang menampilkan teks.

Struktur dasarnya:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
```

Kemudian aplikasi menggunakan:

```dart
MaterialApp
Scaffold
AppBar
Center
Text
```

Pada awalnya ditampilkan:

```text
Halo, nama saya Rizqi!
```

serta nama dan NIM.

Tujuan bagian ini adalah memahami hubungan antara `MaterialApp`, `Scaffold`, `AppBar`, dan widget di bagian `body`.

---

# 9. Bagian E — Layout Dasar

Setelah memahami tampilan sederhana, bagian `body` dikembangkan menggunakan `Column`.

Implementasi yang digunakan:

```dart
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.flutter_dash,
        size: 80,
        color: Colors.blue,
      ),
      const SizedBox(height: 16),
      const Text(
        'Halo, nama saya Rizqi!',
        style: TextStyle(fontSize: 24),
      ),
      const Text('NIM: 20240801035'),
    ],
  ),
),
```

### Pemahaman teknis

`Center` digunakan supaya isi berada di tengah.

`Column` digunakan untuk menyusun widget secara vertikal.

```dart
mainAxisAlignment: MainAxisAlignment.center
```

digunakan supaya isi `Column` berada di tengah pada arah utama.

`SizedBox` digunakan untuk memberikan jarak antar-widget.

Sedangkan `Icon` digunakan untuk menampilkan ikon Flutter.

Dari bagian ini saya mulai memahami bahwa layout Flutter dibangun dengan menggabungkan widget satu dengan widget lainnya.

---

# 10. Bagian F — StatefulWidget dan Counter

Pada bagian ini aplikasi mulai dibuat interaktif.

State yang digunakan:

```dart
int _count = 0;
```

Nilai tersebut ditampilkan menggunakan:

```dart
Text(
  '$_count',
  style: const TextStyle(fontSize: 48),
)
```

Kemudian tombol tambah menggunakan:

```dart
FloatingActionButton(
  onPressed: () => setState(() => _count++),
  child: const Icon(Icons.add),
)
```

Ketika tombol ditekan, `_count` bertambah satu.

### Kenapa menggunakan `setState()`?

Karena `_count` merupakan data yang memengaruhi tampilan.

Ketika nilainya berubah:

```dart
_count++;
```

Flutter perlu diberi tahu bahwa state berubah sehingga bagian UI yang berkaitan dengan state dapat diperbarui.

Hal tersebut dilakukan dengan:

```dart
setState(() {
  _count++;
});
```

---

# 11. Gabungan Bagian D, E, dan F

Setelah bagian D, E, dan F dipahami secara terpisah, saya menggabungkannya menjadi satu aplikasi.

Versi gabungannya mempunyai:

- AppBar.
- Ikon Flutter.
- Nama.
- NIM.
- Nilai counter.
- Tombol tambah.
- `StatefulWidget`.
- `setState()`.

Potongan utama state-nya:

```dart
class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.flutter_dash,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Halo, nama saya Rizqi!',
              style: TextStyle(fontSize: 24),
            ),
            const Text('NIM: 20240801035'),
            Text(
              '$_count',
              style: const TextStyle(fontSize: 48),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _count++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

Pada tahap ini konsep yang dipelajari mulai terlihat menjadi satu alur: widget digunakan untuk membuat UI dan state digunakan untuk membuat bagian tertentu menjadi interaktif.

---

# 12. Latihan 1 — Mengubah Warna

Latihan pertama meminta perubahan warna AppBar dan warna teks.

Pada implementasi saya, AppBar dibuat berwarna cokelat:

```dart
appBar: AppBar(
  backgroundColor: Colors.brown,
  title: const Text(
    'Hello Flutter',
    style: TextStyle(color: Colors.white),
  ),
),
```

Teks juga diberi warna:

```dart
TextStyle(
  fontSize: 24,
  color: Colors.brown,
)
```

Latihan ini cukup sederhana, tetapi membantu memahami bahwa style widget dapat diatur melalui `TextStyle` dan properti seperti `backgroundColor`.

---

# 13. Latihan 2 — Tombol Tambah dan Kurang

Pada latihan kedua ditambahkan tombol `remove`.

Tombol kurang:

```dart
FloatingActionButton(
  onPressed: () => setState(() => _count--),
  child: const Icon(Icons.remove),
),
```

Tombol tambah tetap menggunakan:

```dart
FloatingActionButton(
  onPressed: () => setState(() => _count++),
  child: const Icon(Icons.add),
),
```

Kedua tombol kemudian diletakkan dalam `Row`:

```dart
floatingActionButton: Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    // tombol kurang
    // tombol tambah
  ],
),
```

Dengan `Row`, kedua tombol dapat disusun secara horizontal.

---

# 14. Latihan 3 — Menambahkan Reset

Pada latihan ketiga ditambahkan tombol reset.

Implementasinya:

```dart
FloatingActionButton(
  onPressed: () => setState(() => _count = 0),
  child: const Icon(Icons.refresh),
),
```

Jadi terdapat tiga operasi:

```text
-    Reset    +
```

Secara teknis:

```dart
_count--;
```

digunakan untuk mengurangi nilai.

```dart
_count = 0;
```

digunakan untuk mengembalikan nilai ke kondisi awal.

```dart
_count++;
```

digunakan untuk menambah nilai.

Semua perubahan state dibungkus dengan `setState()`.

---

# 15. Latihan 4 — Mencegah Nilai Negatif

Pada latihan terakhir, nilai counter tidak boleh kurang dari `0`.

Sebelumnya tombol kurang langsung melakukan:

```dart
_count--;
```

Kemudian diberikan kondisi:

```dart
onPressed: () {
  if (_count > 0) {
    setState(() => _count--);
  }
},
```

Logikanya sederhana:

```text
Jika _count > 0
    kurangi nilai
Jika _count = 0
    jangan lakukan apa-apa
```

Dengan kondisi tersebut, counter tidak akan menghasilkan nilai negatif.

Menurut saya bagian ini menjadi latihan yang penting karena mulai memperlihatkan penggunaan logika program pada interaksi UI.

---

# 16. Tugas — Kartu Perkenalan

Setelah menyelesaikan latihan counter, tugas pada modul adalah membuat aplikasi **Kartu Perkenalan** satu halaman.

Data yang ditampilkan:

```text
Nama      : Rizqi
NIM       : 20240801035
Jurusan   : Teknik Informatika
Hobi      : Mancing
```

Selain data tersebut digunakan juga ikon sebagai pengganti foto.

---

## 16.1 Implementasi Kartu Perkenalan

Kode tugas dibuat menggunakan struktur yang masih sesuai dengan materi dasar:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartu Perkenalan',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: const Text(
            'Kartu Perkenalan',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.person,
                size: 80,
                color: Colors.brown,
              ),
              SizedBox(height: 16),
              Text(
                'Nama: Rizqi',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'NIM: 20240801035',
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Jurusan: Teknik Informatika',
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Hobi: Mancing',
                style: TextStyle(
                  color: Colors.brown,
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

---

# 17. Pemahaman Teknis dari Kartu Perkenalan

Walaupun tampilannya sederhana, beberapa konsep Flutter dari modul sudah digunakan sekaligus.

### `MaterialApp`

```dart
MaterialApp(
  title: 'Kartu Perkenalan',
)
```

Digunakan sebagai root aplikasi.

### `Scaffold`

```dart
Scaffold(
  appBar: ...,
  body: ...,
)
```

Digunakan sebagai struktur dasar halaman.

### `AppBar`

```dart
AppBar(
  title: const Text('Kartu Perkenalan'),
)
```

Digunakan sebagai bagian atas halaman.

### `Center`

```dart
Center(
  child: Column(...)
)
```

Digunakan untuk menempatkan isi di tengah halaman.

### `Column`

```dart
Column(
  children: [...]
)
```

Digunakan untuk menyusun data secara vertikal.

### `Icon`

```dart
Icon(
  Icons.person,
  size: 80,
)
```

Digunakan sebagai representasi foto/identitas pada kartu.

### `Text`

Digunakan untuk menampilkan informasi pengguna.

### `SizedBox`

```dart
SizedBox(height: 8)
```

Digunakan untuk memberikan jarak antar informasi supaya tampilan tidak terlalu rapat.

---

# 18. Alur Pengerjaan

Secara keseluruhan, proses pengerjaan praktikum saya dilakukan secara bertahap.

```text
Persiapan Flutter
       ↓
flutter doctor
       ↓
Membuat project
       ↓
flutter create praktikum_1
       ↓
Menjalankan project
       ↓
Memahami main.dart
       ↓
Hello Flutter
       ↓
Layout dengan Column
       ↓
StatefulWidget + Counter
       ↓
Latihan 1
       ↓
Latihan 2
       ↓
Latihan 3
       ↓
Latihan 4
       ↓
Kartu Perkenalan
       ↓
Selesai
```

Setiap tahap merupakan pengembangan dari tahap sebelumnya. Jadi kode tidak langsung dibuat menjadi tugas akhir, tetapi dimulai dari tampilan yang paling sederhana kemudian ditambahkan layout, state, interaksi, dan terakhir dibuat menjadi Kartu Perkenalan.

---

# 19. Hot Reload

Salah satu fitur Flutter yang digunakan selama proses pengerjaan adalah **hot reload**.

Setelah kode diubah dan disimpan, perubahan dapat dilihat pada aplikasi tanpa harus menjalankan ulang seluruh proses dari awal.

Contohnya ketika warna:

```dart
backgroundColor: Colors.brown,
```

diubah, tampilan dapat diperiksa kembali menggunakan hot reload.

Menurut saya fitur ini cukup membantu selama praktikum karena proses mencoba perubahan UI menjadi lebih cepat.

---

# 20. Hal yang Dipahami Setelah Praktikum

Setelah menyelesaikan modul ini, beberapa hal yang saya pahami adalah:

1. Flutter menggunakan Dart sebagai bahasa pemrogramannya.
2. UI Flutter dibangun menggunakan widget.
3. Widget dapat disusun menjadi widget tree.
4. `StatelessWidget` digunakan untuk widget yang tidak membutuhkan perubahan state.
5. `StatefulWidget` digunakan ketika terdapat state yang dapat berubah.
6. `setState()` digunakan ketika state pada widget perlu diperbarui.
7. `Column` digunakan untuk menyusun widget secara vertikal.
8. `Row` digunakan untuk menyusun widget secara horizontal.
9. `SizedBox` dapat digunakan untuk memberikan jarak.
10. `TextStyle` digunakan untuk mengatur tampilan teks.
11. `FloatingActionButton` dapat digunakan untuk membuat tombol aksi.
12. Hot reload mempercepat proses melihat perubahan kode.
13. Struktur project Flutter memiliki fungsi yang berbeda antara `lib`, `android`, `ios`, `test`, dan `pubspec.yaml`.

---

# 21. Kesimpulan

Praktikum Pertemuan 1 menjadi tahap awal untuk memahami cara kerja Flutter. Dari praktikum ini saya tidak hanya belajar membuat tampilan, tetapi juga mulai memahami bagaimana widget disusun dan bagaimana perubahan data dapat memengaruhi tampilan aplikasi.

Prosesnya dimulai dari pengecekan environment menggunakan `flutter doctor`, membuat project Flutter, mencoba aplikasi counter bawaan, kemudian memahami `main.dart` dan widget dasar.

Setelah itu materi berkembang dari `StatelessWidget` menuju `StatefulWidget`. Counter digunakan untuk memahami state dan `setState()`. Dari counter tersebut kemudian dilakukan beberapa latihan, yaitu mengubah warna, menambah tombol kurang, membuat reset, dan mencegah nilai menjadi negatif.

Pada bagian akhir, konsep yang sudah dipelajari diterapkan pada tugas **Kartu Perkenalan**. Aplikasi tersebut menggunakan `MaterialApp`, `Scaffold`, `AppBar`, `Center`, `Column`, `Icon`, `Text`, dan `SizedBox` untuk membuat satu halaman informasi diri.

Dengan begitu, hasil akhir praktikum bukan hanya sebuah aplikasi yang berjalan, tetapi juga menjadi latihan dasar untuk memahami pola pembuatan UI Flutter sebelum masuk ke materi yang lebih kompleks.

---

## 22. Hasil Akhir

Hasil akhir yang dibuat adalah aplikasi **Kartu Perkenalan** dengan tampilan satu halaman yang berisi:

```text
┌─────────────────────────────┐
│      Kartu Perkenalan       │
├─────────────────────────────┤
│                             │
│            👤               │
│                             │
│       Nama: Rizqi           │
│       NIM: 20240801035      │
│       Jurusan: Teknik       │
│       Informatika           │
│       Hobi: Mancing         │
│                             │
└─────────────────────────────┘
```

Selain tugas akhir tersebut, proses pengerjaan juga menghasilkan pemahaman dan implementasi dari seluruh checkpoint D sampai F serta latihan mandiri pada modul.

---

## 23. Referensi

Materi praktikum mengacu pada:

- Modul **Praktikum Flutter Fundamental — Pertemuan 1: Pengenalan Flutter, Instalasi, dan Aplikasi Pertama**
- Dokumentasi Flutter: https://docs.flutter.dev/
- Dart Language Tour: https://dart.dev/language
- Flutter Widget Catalog: https://docs.flutter.dev/ui/widgets

---

### Catatan

README ini dibuat berdasarkan proses praktikum Pertemuan 1 dan implementasi `main.dart` yang digunakan selama pengerjaan. Screenshot hasil aplikasi dapat ditambahkan pada bagian **Hasil Akhir** jika diperlukan untuk kebutuhan pengumpulan.
