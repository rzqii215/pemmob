# Praktikum Flutter Fundamental — Pertemuan 3

> **Mata Kuliah:** Pemrograman Mobile  
> **Praktikum:** Flutter Fundamental  
> **Pertemuan:** 3  
> **Nama:** Muhamad Rizqi Candra  
> **NIM:** 20240801035  
> **Prodi:** Teknik Informatika

---

## 1. Gambaran Umum

Pada praktikum pertemuan 3 ini saya mempelajari bagaimana cara menerima input dari pengguna, membuat form yang mempunyai validasi, dan mengatur data yang digunakan oleh lebih dari satu halaman.

Materi pada pertemuan ini tidak hanya membahas tampilan Flutter, tetapi mulai masuk ke bagian bagaimana sebuah aplikasi menyimpan dan mengubah data. Pada bagian awal saya menggunakan `setState` untuk data yang masih berada di satu halaman. Setelah itu saya mencoba menggunakan `ChangeNotifier` dan `Provider` ketika data mulai digunakan oleh beberapa halaman.

Praktikum ini terdiri dari beberapa tahap, yaitu:

1. Input dasar menggunakan `TextField`.
2. Form dengan validasi.
3. Memahami alasan penggunaan state management.
4. Membuat aplikasi daftar tugas menggunakan Provider.
5. Mengerjakan latihan mandiri secara bertahap.
6. Menerapkan konsep yang sama pada tugas akhir berupa aplikasi **Daftar Belanja**.

Menurut saya, bagian yang paling penting dari praktikum ini adalah memahami perbedaan antara state lokal dan state yang perlu dibagikan. Jadi, kode yang dibuat bukan hanya untuk menghasilkan tampilan, tetapi juga untuk memahami bagaimana data bergerak dari satu halaman ke halaman lainnya.

---

## 2. Tujuan Praktikum

Berdasarkan modul, tujuan yang ingin dicapai pada praktikum ini adalah:

- Mengambil input pengguna menggunakan `TextField` dan `TextEditingController`.
- Membuat form dengan `Form`, `TextFormField`, dropdown, dan checkbox.
- Memahami keterbatasan `setState` ketika data digunakan oleh beberapa halaman.
- Menerapkan state management dasar menggunakan `ChangeNotifier` dan `Provider`.
- Membedakan penggunaan `context.watch()` dan `context.read()`.

Tujuan tersebut kemudian saya terapkan secara bertahap melalui kode yang dibuat selama praktikum.

---

## 3. Persiapan

### Tools yang digunakan

- Flutter SDK
- Visual Studio Code / editor
- Emulator atau perangkat untuk menjalankan aplikasi
- Dart
- Package `provider`

Project Flutter dibuat dengan perintah:

```bash
flutter create praktikum_3
```

Untuk menggunakan Provider, package ditambahkan melalui terminal:

```bash
flutter pub add provider
```

Setelah package berhasil ditambahkan, project dapat menggunakan:

```dart
import 'package:provider/provider.dart';
```

---

# 4. Pemahaman Materi

## 4.1 TextField dan TextEditingController

`TextField` digunakan untuk menerima input berupa teks dari pengguna. Agar isi dari input tersebut dapat dibaca melalui kode, digunakan `TextEditingController`.

Contoh yang saya gunakan:

```dart
final _controller = TextEditingController();
```

Controller kemudian dipasang pada `TextField`:

```dart
TextField(
  controller: _controller,
  decoration: const InputDecoration(
    labelText: 'Nama',
    border: OutlineInputBorder(),
  ),
)
```

Isi input dapat diambil menggunakan:

```dart
_controller.text
```

Karena controller menggunakan resource yang perlu dikelola, controller juga harus dilepas ketika widget sudah tidak digunakan:

```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

Dari bagian ini saya memahami bahwa `TextEditingController` berfungsi sebagai penghubung antara input pengguna dengan kode Dart.

---

## 4.2 Form dan Validasi

Jika hanya satu input, `TextField` sudah cukup. Tetapi jika terdapat beberapa input yang harus diperiksa sebelum data diproses, digunakan `Form`.

Form diberikan sebuah key:

```dart
final _formKey = GlobalKey<FormState>();
```

Kemudian key tersebut dipasang pada `Form`:

```dart
Form(
  key: _formKey,
  child: ...
)
```

Validasi dijalankan dengan:

```dart
_formKey.currentState!.validate()
```

Setiap `TextFormField` mempunyai `validator`. Jika input tidak sesuai, validator mengembalikan pesan error. Jika input benar, validator mengembalikan `null`.

Contohnya:

```dart
validator: (v) {
  if (v == null || v.trim().isEmpty) {
    return 'Nama wajib diisi';
  }

  return null;
}
```

Jadi alurnya adalah:

```text
User mengisi form
        ↓
Tombol ditekan
        ↓
validate()
        ↓
Validator memeriksa setiap input
        ↓
Jika salah → tampil pesan error
Jika benar → data dapat diproses
```

---

## 4.3 Dropdown dan Checkbox

Pada form saya juga menggunakan dropdown untuk memilih jurusan.

```dart
DropdownButtonFormField<String>(
  ...
)
```

Nilai pilihan disimpan pada:

```dart
String? _jurusan;
```

Sementara checkbox digunakan untuk menyimpan persetujuan pengguna:

```dart
bool _setuju = false;
```

Tombol daftar hanya dapat digunakan ketika checkbox sudah dicentang:

```dart
onPressed: _setuju ? _kirim : null,
```

Dari sini saya memahami bahwa widget input tidak hanya digunakan untuk menerima teks. Flutter juga menyediakan komponen input lain yang dapat menyimpan state sesuai kebutuhan.

---

# 5. Bagian A — Input Dasar

Pada Bagian A saya membuat halaman `InputPage`.

Halaman ini menggunakan:

- `StatefulWidget`
- `TextField`
- `TextEditingController`
- `setState`
- `ElevatedButton`

Input nama disimpan melalui controller:

```dart
final _controller = TextEditingController();
```

Ketika tombol **Sapa** ditekan, nilai input digunakan untuk mengubah teks sapaan:

```dart
setState(() {
  _salam = 'Halo, ${_controller.text}!';
});
```

### Pemahaman saya

Pada tahap ini saya mulai memahami konsep state sederhana. Variabel `_salam` dapat berubah dan perubahan tersebut memengaruhi tampilan.

Karena perubahan hanya terjadi pada halaman `InputPage`, penggunaan `setState` masih cukup.

### Hasil yang diharapkan

Misalnya pengguna memasukkan:

```text
Riski
```

kemudian menekan tombol **Sapa**, maka akan muncul:

```text
Halo, Riski!
```

---

# 6. Bagian B — Form dengan Validasi

Pada Bagian B saya membuat `FormPage`.

Form ini memiliki beberapa input:

- Nama lengkap
- Email
- Jurusan
- Persetujuan ketentuan

### Validasi nama

Nama tidak boleh kosong:

```dart
validator: (v) =>
    (v == null || v.trim().isEmpty)
        ? 'Nama wajib diisi'
        : null,
```

### Validasi email

Email diperiksa menggunakan karakter `@`:

```dart
validator: (v) {
  if (v == null || !v.contains('@')) {
    return 'Email tidak valid';
  }

  return null;
}
```

### Validasi jurusan

Jurusan harus dipilih:

```dart
validator: (v) =>
    v == null ? 'Pilih jurusan' : null,
```

### Checkbox

Nilai checkbox disimpan pada:

```dart
bool _setuju = false;
```

Tombol daftar dibuat aktif hanya jika `_setuju` bernilai `true`.

### Hasil

Jika data belum benar, Flutter menampilkan pesan validasi berwarna merah.

Jika semua input valid dan checkbox sudah dicentang, data diproses dan muncul `SnackBar`.

Contohnya:

```text
Terdaftar: Riski (TI)
```

### Pemahaman saya

Pada bagian ini saya mulai memahami bahwa validasi sebaiknya dilakukan sebelum data diproses. Dengan menggunakan `Form` dan `validator`, pengecekan setiap input menjadi lebih terstruktur.

---

# 7. Bagian C — Mengapa Membutuhkan State Management?

Bagian C menjelaskan masalah yang mulai muncul ketika data digunakan oleh beberapa halaman.

Contohnya pada aplikasi daftar tugas:

```text
Halaman Daftar Tugas
        ↕
     Data Tugas
        ↕
Halaman Tambah Tugas
```

Halaman daftar menampilkan data, sedangkan halaman tambah digunakan untuk memasukkan data baru.

Jika hanya menggunakan `setState`, data dapat menjadi sulit untuk dibagikan ketika jumlah halaman bertambah. Data bisa saja harus dikirim melalui constructor atau callback dari satu halaman ke halaman lain.

Karena itu digunakan satu objek state yang dapat diakses oleh beberapa widget.

Pada praktikum ini, solusi yang digunakan adalah:

```text
ChangeNotifier
      +
   Provider
```

---

# 8. Bagian D — Daftar Tugas dengan Provider

Pada Bagian D saya membuat aplikasi sederhana **Daftar Tugas**.

Struktur dasarnya terdiri dari:

```text
Tugas
  ↓
TugasModel
  ↓
ChangeNotifierProvider
  ↓
TugasPage
  ↓
TambahPage
```

## 8.1 Model Tugas

Data tugas dibuat melalui class:

```dart
class Tugas {
  String judul;
  bool selesai;

  Tugas(this.judul, {this.selesai = false});
}
```

Setiap tugas memiliki dua informasi utama:

- `judul`
- `selesai`

---

## 8.2 TugasModel

State aplikasi disimpan pada `TugasModel`:

```dart
class TugasModel extends ChangeNotifier {
  final List<Tugas> _items = [];
}
```

Model ini memiliki beberapa fungsi.

### Menambahkan tugas

```dart
void tambah(String judul) {
  _items.add(Tugas(judul));
  notifyListeners();
}
```

### Mengubah status tugas

```dart
void toggle(int index) {
  _items[index].selesai = !_items[index].selesai;
  notifyListeners();
}
```

### Menghapus tugas

```dart
void hapus(int index) {
  _items.removeAt(index);
  notifyListeners();
}
```

`notifyListeners()` digunakan untuk memberi tahu widget yang sedang mendengarkan state bahwa data sudah berubah.

---

# 9. ChangeNotifierProvider

Agar `TugasModel` dapat digunakan oleh halaman lain, model diletakkan di atas widget yang membutuhkannya:

```dart
ChangeNotifierProvider(
  create: (_) => TugasModel(),
  child: const MyApp(),
)
```

Dengan begitu, `TugasPage` dan `TambahPage` dapat mengakses model yang sama.

Hal ini yang membuat data yang ditambahkan dari halaman kedua dapat langsung terlihat pada halaman daftar.

---

# 10. context.watch dan context.read

Dua penggunaan Provider yang saya terapkan adalah `context.watch()` dan `context.read()`.

## context.watch()

Pada halaman daftar:

```dart
final model = context.watch<TugasModel>();
```

`watch` digunakan ketika widget perlu mengikuti perubahan data.

Misalnya jumlah tugas berubah, tampilan `AppBar` juga perlu diperbarui.

```dart
title: Text(
  'Tugas (${model.jumlahSelesai}/${model.items.length})',
),
```

## context.read()

Untuk menjalankan aksi, saya menggunakan:

```dart
context.read<TugasModel>().toggle(i);
```

dan:

```dart
context.read<TugasModel>().hapus(i);
```

`read` digunakan untuk mengambil model tanpa membuat widget tersebut ikut mendengarkan perubahan state.

### Pemahaman saya

Cara sederhananya saya pahami seperti ini:

```text
watch → saya perlu mengetahui perubahan data

read  → saya hanya perlu menjalankan aksi terhadap data
```

---

# 11. Halaman Tambah Tugas

Halaman `TambahPage` digunakan untuk memasukkan tugas baru.

Input menggunakan:

```dart
final _controller = TextEditingController();
```

Ketika tombol **Simpan** ditekan:

```dart
final judul = _controller.text.trim();

if (judul.isEmpty) return;

context.read<TugasModel>().tambah(judul);

Navigator.pop(context);
```

Alurnya:

```text
User mengetik tugas
        ↓
Tombol Simpan
        ↓
Ambil isi controller
        ↓
Cek apakah kosong
        ↓
TugasModel.tambah()
        ↓
notifyListeners()
        ↓
Kembali ke halaman daftar
        ↓
Daftar diperbarui
```

---

# 12. Latihan Mandiri

Setelah aplikasi daftar tugas dari Bagian D berhasil dibuat, saya melanjutkan latihan secara bertahap.

## Latihan 1 — Validasi Minimal 3 Karakter

`TambahPage` diubah dari `TextField` menjadi `TextFormField`.

Saya menambahkan:

```dart
final _formKey = GlobalKey<FormState>();
```

Kemudian validator:

```dart
validator: (v) {
  if (v == null || v.trim().length < 3) {
    return 'Judul minimal 3 karakter';
  }

  return null;
}
```

Dengan demikian, tugas yang panjangnya kurang dari 3 karakter tidak dapat disimpan.

---

## Latihan 2 — Menghapus Semua Tugas yang Sudah Selesai

Saya menambahkan method:

```dart
void hapusSelesai() {
  _items.removeWhere((t) => t.selesai);
  notifyListeners();
}
```

Kemudian menambahkan tombol pada `AppBar`:

```dart
IconButton(
  icon: const Icon(Icons.delete_sweep),
  onPressed: () {
    context.read<TugasModel>().hapusSelesai();
  },
)
```

Jadi tugas yang sudah dicentang dapat dihapus sekaligus.

---

## Latihan 3 — SnackBar

Setelah tugas berhasil ditambahkan, saya menampilkan:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Tugas ditambahkan'),
  ),
);
```

Tujuannya supaya pengguna mendapat informasi bahwa data berhasil diproses.

---

## Latihan 4 — Empty State

Jika belum ada tugas, sebelumnya `ListView` tidak menampilkan apa-apa.

Saya kemudian membuat kondisi:

```dart
body: model.items.isEmpty
    ? const Center(
        child: Text('Belum ada tugas'),
      )
    : ListView.builder(
        ...
      ),
```

Hasilnya ketika daftar kosong akan muncul:

```text
Belum ada tugas
```

Ini membuat kondisi kosong lebih jelas bagi pengguna.

---

# 13. Tugas Utama — Aplikasi Daftar Belanja

Setelah menyelesaikan latihan, konsep yang sama diterapkan pada tugas utama.

Tugas pada modul meminta aplikasi **Daftar Belanja** dengan:

- Nama barang wajib diisi.
- Jumlah wajib diisi.
- Jumlah harus berupa angka lebih dari 0.
- Kategori menggunakan dropdown.
- Data dapat ditandai sebagai sudah dibeli.
- Data dapat dihapus.
- State menggunakan satu `ChangeNotifier`.
- State dibagikan menggunakan Provider.
- AppBar menampilkan jumlah barang yang belum dibeli.

---

# 14. Model Barang

Saya membuat class baru bernama `Barang`:

```dart
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
```

Setiap barang mempunyai empat data:

| Data | Fungsi |
|---|---|
| `nama` | Menyimpan nama barang |
| `jumlah` | Menyimpan jumlah barang |
| `kategori` | Menyimpan kategori |
| `sudahDibeli` | Menyimpan status pembelian |

---

# 15. BelanjaModel

State untuk aplikasi Daftar Belanja disimpan pada:

```dart
class BelanjaModel extends ChangeNotifier {
  final List<Barang> _items = [];
}
```

Jumlah barang yang belum dibeli dihitung melalui getter:

```dart
int get jumlahBelumDibeli =>
    _items.where((barang) => !barang.sudahDibeli).length;
```

Artinya hanya barang yang memiliki:

```dart
sudahDibeli == false
```

yang dihitung.

---

## 15.1 Menambahkan Barang

Method yang digunakan:

```dart
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
```

Setelah data ditambahkan, `notifyListeners()` dipanggil supaya halaman daftar mengetahui bahwa data sudah berubah.

---

## 15.2 Mengubah Status Barang

Checkbox menggunakan method:

```dart
void toggle(int index) {
  _items[index].sudahDibeli =
      !_items[index].sudahDibeli;

  notifyListeners();
}
```

Jika sebelumnya belum dibeli, maka menjadi sudah dibeli. Begitu juga sebaliknya.

---

## 15.3 Menghapus Barang

Method hapus:

```dart
void hapus(int index) {
  _items.removeAt(index);
  notifyListeners();
}
```

---

# 16. Halaman Daftar Belanja

Halaman utama menggunakan:

```dart
final model = context.watch<BelanjaModel>();
```

Kemudian jumlah barang yang belum dibeli ditampilkan di AppBar:

```dart
title: Text(
  'Belum Dibeli (${model.jumlahBelumDibeli})',
),
```

Daftar barang ditampilkan menggunakan:

```dart
ListView.builder
```

Setiap barang mempunyai:

- Checkbox
- Nama barang
- Jumlah
- Kategori
- Tombol hapus

Contoh informasi yang ditampilkan:

```text
Beras
Jumlah: 2 | Kategori: Makanan
```

Jika barang dicentang, nama barang akan dicoret menggunakan:

```dart
decoration: barang.sudahDibeli
    ? TextDecoration.lineThrough
    : null,
```

---

# 17. Halaman Tambah Barang

Form tambah barang menggunakan:

```dart
Form(
  key: _formKey,
  ...
)
```

Ada tiga input utama:

### Nama Barang

```dart
validator: (v) {
  if (v == null || v.trim().isEmpty) {
    return 'Nama barang wajib diisi';
  }

  return null;
}
```

### Jumlah

Jumlah diperiksa menggunakan `int.tryParse()`:

```dart
final jumlah = int.tryParse(v);

if (jumlah == null || jumlah <= 0) {
  return 'Jumlah harus angka lebih dari 0';
}
```

Saya menggunakan `tryParse()` supaya input yang bukan angka tidak langsung menyebabkan error saat proses konversi.

### Kategori

Kategori menggunakan:

```dart
DropdownButtonFormField<String>
```

Pilihan yang saya buat:

- Makanan
- Minuman
- Lainnya

Kategori wajib dipilih sebelum data dapat disimpan.

---

# 18. Proses Penyimpanan Data

Ketika tombol **Simpan** ditekan, form terlebih dahulu divalidasi:

```dart
if (_formKey.currentState!.validate()) {
```

Jika valid, data dikirim ke `BelanjaModel`:

```dart
context.read<BelanjaModel>().tambah(
  _nama.text.trim(),
  int.parse(_jumlah.text),
  _kategori!,
);
```

Setelah data berhasil dimasukkan, halaman kembali ke halaman daftar:

```dart
Navigator.pop(context);
```

Alur lengkapnya:

```text
Form Tambah Barang
        ↓
User mengisi nama
        ↓
User mengisi jumlah
        ↓
User memilih kategori
        ↓
Tekan Simpan
        ↓
validate()
        ↓
Data valid?
   ↙          ↘
 Tidak        Ya
  ↓            ↓
Error       BelanjaModel
               ↓
             tambah()
               ↓
        notifyListeners()
               ↓
        Kembali ke daftar
               ↓
        Data langsung tampil
```

---

# 19. Alur Keseluruhan Praktikum

Secara keseluruhan, proses pengerjaan saya dapat digambarkan seperti berikut:

```text
Mulai
  ↓
Mempelajari TextField
  ↓
Membuat InputPage
  ↓
Memahami TextEditingController
  ↓
Membuat FormPage
  ↓
Menambahkan validasi
  ↓
Memahami setState
  ↓
Memahami masalah state antar halaman
  ↓
Memasang Provider
  ↓
Membuat ChangeNotifier
  ↓
Membuat Daftar Tugas
  ↓
Menggunakan context.watch
  ↓
Menggunakan context.read
  ↓
Mengerjakan Latihan 1
  ↓
Mengerjakan Latihan 2
  ↓
Mengerjakan Latihan 3
  ↓
Mengerjakan Latihan 4
  ↓
Menerapkan konsep pada Daftar Belanja
  ↓
Menambahkan validasi
  ↓
Menghubungkan Form dengan Provider
  ↓
Menguji tambah, centang, dan hapus
  ↓
Selesai
```

---

# 20. Perbandingan setState dan Provider

Dari praktikum ini saya memahami bahwa `setState` dan Provider bukan berarti salah satu harus selalu menggantikan yang lain.

| `setState` | Provider |
|---|---|
| Cocok untuk state lokal | Cocok untuk state yang digunakan beberapa widget/halaman |
| Sederhana digunakan | Memerlukan model dan provider |
| State berada pada widget | State dapat dipusatkan pada model |
| Contoh: checkbox lokal | Contoh: daftar tugas dan daftar belanja |
| Rebuild dikelola oleh widget tersebut | Widget yang melakukan `watch` mengikuti perubahan model |

Jadi, untuk kasus sederhana seperti input dasar, `setState` masih cukup. Ketika data perlu digunakan oleh beberapa halaman, Provider menjadi lebih masuk akal untuk digunakan.

---

# 21. Hasil Implementasi

Setelah seluruh kode dibuat, aplikasi yang dihasilkan memiliki beberapa fungsi utama.

## Bagian A

Input nama melalui `TextField` dan menampilkan sapaan setelah tombol ditekan.

```text
Nama
[_____________________]

[Sapa]

Halo, Riski!
```

## Bagian B

Form pendaftaran dengan:

```text
Nama lengkap
[_____________________]

Email
[_____________________]

Jurusan
[ Teknik Informatika ▼ ]

☐ Saya menyetujui ketentuan

[Daftar]
```

Jika data tidak sesuai, pesan validasi ditampilkan pada field yang bermasalah.

## Daftar Tugas

Aplikasi dapat:

- Menambah tugas.
- Menandai tugas selesai.
- Mencoret tugas selesai.
- Menghapus tugas.
- Menghapus seluruh tugas yang selesai.
- Menampilkan jumlah tugas.
- Menampilkan pesan ketika daftar kosong.
- Menampilkan SnackBar setelah tugas ditambahkan.

## Daftar Belanja

Aplikasi akhir dapat:

- Menambahkan barang.
- Memvalidasi nama barang.
- Memvalidasi jumlah.
- Memvalidasi kategori.
- Menampilkan daftar barang.
- Menandai barang sebagai sudah dibeli.
- Mencoret barang yang sudah dibeli.
- Menghapus barang.
- Menampilkan jumlah barang yang belum dibeli.

---

# 22. Pengujian yang Dilakukan

Beberapa kondisi yang perlu diuji dari aplikasi:

| Pengujian | Hasil yang diharapkan |
|---|---|
| Nama barang dikosongkan | Muncul `Nama barang wajib diisi` |
| Jumlah dikosongkan | Muncul `Jumlah wajib diisi` |
| Jumlah diisi teks | Muncul `Jumlah harus angka lebih dari 0` |
| Jumlah diisi `0` | Ditolak |
| Jumlah diisi angka negatif | Ditolak |
| Kategori tidak dipilih | Muncul pesan validasi |
| Data valid | Barang berhasil ditambahkan |
| Barang dicentang | Status berubah menjadi sudah dibeli |
| Barang sudah dibeli | Nama barang dicoret |
| Barang dihapus | Barang hilang dari daftar |
| Semua barang belum dibeli | Jumlah pada AppBar mengikuti jumlah barang |
| Daftar tugas kosong | Muncul `Belum ada tugas` |

---

# 23. Pembahasan Teknis

## Kenapa menggunakan `List.unmodifiable()`?

Pada model digunakan:

```dart
List<Barang> get items => List.unmodifiable(_items);
```

Data asli tetap dikelola oleh model. Halaman hanya mendapatkan versi list yang tidak dapat dimodifikasi secara langsung.

Dengan cara ini, perubahan data tetap dilakukan melalui method yang disediakan model, seperti:

```dart
tambah()
toggle()
hapus()
```

---

## Kenapa setiap perubahan memanggil `notifyListeners()`?

Provider perlu mengetahui bahwa state telah berubah.

Contohnya:

```dart
void hapus(int index) {
  _items.removeAt(index);
  notifyListeners();
}
```

Jika data diubah tetapi `notifyListeners()` tidak dipanggil, widget yang menggunakan `context.watch()` tidak mendapat pemberitahuan untuk membangun ulang tampilan.

---

## Kenapa `context.watch()` digunakan di `build()`?

Pada halaman daftar, data harus selalu mengikuti perubahan state.

Contohnya:

```dart
final model = context.watch<BelanjaModel>();
```

Ketika jumlah atau isi `_items` berubah, halaman akan mendapatkan perubahan tersebut dan tampilan dapat diperbarui.

---

## Kenapa `context.read()` digunakan pada tombol?

Pada tombol, kebutuhan utamanya adalah menjalankan method pada model.

Contohnya:

```dart
context.read<BelanjaModel>().hapus(index);
```

Tombol tidak perlu menjadi pendengar perubahan state. Ia hanya perlu mengambil model kemudian menjalankan method `hapus()`.

---

## Kenapa menggunakan `ListView` pada form?

Form dapat berisi beberapa input dan pada layar yang lebih kecil keyboard dapat menyebabkan bagian bawah halaman tertutup.

Dengan `ListView`, isi form dapat digulir sehingga input tetap dapat diakses.

---

# 24. Struktur Konsep Aplikasi

Struktur konsep aplikasi akhir dapat dipahami seperti ini:

```text
                   ┌─────────────────────┐
                   │  BelanjaModel       │
                   │  ChangeNotifier     │
                   └─────────┬───────────┘
                             │
                    Provider │
                             ↓
              ┌──────────────┴──────────────┐
              │                             │
              ↓                             ↓
   ┌──────────────────┐          ┌──────────────────┐
   │ DaftarBelanjaPage│          │TambahBarangPage  │
   │                  │          │                  │
   │ context.watch    │          │ context.read     │
   │                  │          │ Form + Validator │
   └──────────────────┘          └──────────────────┘
              │                             │
              │                             │
              └──────────── Data ───────────┘
```

Dengan struktur tersebut, kedua halaman tidak perlu membawa data satu sama lain melalui constructor. Keduanya cukup mengakses `BelanjaModel` yang sama melalui Provider.

---

# 25. Kesimpulan

Dari praktikum Pertemuan 3 ini saya mendapatkan pemahaman bahwa pembuatan aplikasi Flutter tidak hanya berkaitan dengan membuat tampilan. Data yang masuk dari pengguna juga harus dikelola dengan baik.

Pada awal praktikum saya menggunakan `TextField` dan `TextEditingController` untuk mengambil input. Setelah itu saya menggunakan `Form` dan validator supaya input dapat diperiksa sebelum diproses.

Saya juga memahami bahwa `setState` masih cocok untuk state yang sederhana dan berada dalam satu halaman. Ketika data mulai digunakan oleh beberapa halaman, state management dibutuhkan supaya pengelolaan data tidak menjadi terlalu rumit.

Melalui `ChangeNotifier` dan `Provider`, data dapat ditempatkan pada satu model dan digunakan oleh beberapa halaman. `context.watch()` digunakan ketika widget perlu mengikuti perubahan data, sedangkan `context.read()` digunakan ketika hanya perlu menjalankan suatu aksi.

Pada akhirnya konsep tersebut saya terapkan pada aplikasi **Daftar Belanja**. Aplikasi tersebut memiliki form tambah barang dengan validasi, daftar barang, status sudah dibeli, fitur hapus, serta jumlah barang yang belum dibeli pada AppBar.

Menurut saya, bagian yang paling membantu dari praktikum ini adalah proses pengerjaan secara bertahap. Fitur pada aplikasi daftar tugas ditambahkan satu per satu melalui latihan, kemudian konsep yang sama digunakan untuk menyelesaikan aplikasi Daftar Belanja.

---

# 26. Checklist Penyelesaian

- [x] Memahami `TextField`
- [x] Menggunakan `TextEditingController`
- [x] Melakukan `dispose()` pada controller
- [x] Membuat `Form`
- [x] Menggunakan `TextFormField`
- [x] Membuat validasi input
- [x] Menggunakan dropdown
- [x] Menggunakan checkbox
- [x] Memahami `setState`
- [x] Memahami `ChangeNotifier`
- [x] Memasang Provider
- [x] Menggunakan `context.watch()`
- [x] Menggunakan `context.read()`
- [x] Membuat aplikasi Daftar Tugas
- [x] Menambahkan validasi minimal 3 karakter
- [x] Menambahkan fitur hapus tugas selesai
- [x] Menambahkan SnackBar
- [x] Menambahkan empty state
- [x] Membuat aplikasi Daftar Belanja
- [x] Membuat validasi nama barang
- [x] Membuat validasi jumlah
- [x] Membuat validasi kategori
- [x] Menggunakan `ChangeNotifier` untuk state Daftar Belanja
- [x] Menggunakan Provider
- [x] Menambahkan fitur centang barang
- [x] Menambahkan fitur hapus barang
- [x] Menampilkan jumlah barang yang belum dibeli

---

## Referensi Modul

Materi utama README ini disusun berdasarkan:

> **Modul Praktikum Flutter Fundamental — Pertemuan 3: Form Input dan State Management**

Referensi yang tercantum pada modul:

- Flutter — Forms: `docs.flutter.dev/cookbook/forms`
- Flutter — State Management: `docs.flutter.dev/data-and-backend/state-mgmt`
- Provider Package: `pub.dev/packages/provider`

---

> **Catatan:** README ini mendokumentasikan proses belajar dan implementasi berdasarkan kode yang dibuat pada praktikum. Beberapa bagian kode ditampilkan sebagai contoh teknis untuk menjelaskan konsep, sedangkan implementasi lengkap berada pada project Flutter.
