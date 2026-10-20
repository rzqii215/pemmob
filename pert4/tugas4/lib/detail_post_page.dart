import 'package:flutter/material.dart';

import 'api_service.dart';
import 'model.dart';

class DetailPostPage extends StatefulWidget {
  final Post post;

  const DetailPostPage({
    super.key,
    required this.post,
  });

  @override
  State<DetailPostPage> createState() =>
      _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  late Future<List<Komentar>> _futureKomentar;

  @override
  void initState() {
    super.initState();

    _futureKomentar = ambilKomentar(
      widget.post.id,
    );
  }

  void _muatUlang() {
    setState(() {
      _futureKomentar = ambilKomentar(
        widget.post.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Postingan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.post.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.post.body,
          ),
          const SizedBox(height: 24),
          const Text(
            'Komentar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<Komentar>>(
            future: _futureKomentar,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Terjadi kesalahan:\n${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _muatUlang,
                          child: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final data = snapshot.data!;

              return Column(
                children: data.map((komentar) {
                  return ListTile(
                    title: Text(
                      komentar.name,
                    ),
                    subtitle: Text(
                      '${komentar.email}\n\n${komentar.body}',
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}