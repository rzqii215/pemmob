import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

class Komentar {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  const Komentar({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      postId: json['postId'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }
}

Future<List<Post>> ambilPost() async {
  final uri = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts',
  );

  final response = await http
      .get(uri)
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception(
      'Gagal memuat postingan (kode ${response.statusCode})',
    );
  }

  final List<dynamic> data = jsonDecode(response.body);

  return data
      .map(
        (e) => Post.fromJson(
      e as Map<String, dynamic>,
    ),
  )
      .toList();
}

Future<List<Komentar>> ambilKomentar(int postId) async {
  final uri = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts/$postId/comments',
  );

  final response = await http
      .get(uri)
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception(
      'Gagal memuat komentar (kode ${response.statusCode})',
    );
  }

  final List<dynamic> data = jsonDecode(response.body);

  return data
      .map(
        (e) => Komentar.fromJson(
      e as Map<String, dynamic>,
    ),
  )
      .toList();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 4',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const PostPage(),
    );
  }
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late Future<List<Post>> _future;

  @override
  void initState() {
    super.initState();
    _future = ambilPost();
  }

  void _muatUlang() {
    setState(() {
      _future = ambilPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Postingan'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _future,
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

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final post = data[i];

              return ListTile(
                title: Text(post.title),
                subtitle: Text(
                  post.body.length > 50
                      ? '${post.body.substring(0, 50)}...'
                      : post.body,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPostPage(
                        post: post,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

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