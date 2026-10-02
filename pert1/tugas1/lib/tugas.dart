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