import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Kontak',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const KontakPage(),
    );
  }
}

class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kontak'),
      ),
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
    );
  }
}

class DetailKontakPage extends StatelessWidget {
  final Kontak kontak;

  const DetailKontakPage({
    super.key,
    required this.kontak,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kontak.nama),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                kontak.nama[0],
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}