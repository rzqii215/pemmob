import 'package:flutter/material.dart';

import 'models/kegiatan.dart';
import 'pages/form_kegiatan_page.dart';
import 'pages/shell_page.dart';
import 'state/pengaturan.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final pengaturan = Pengaturan();

  await pengaturan.muat();

  runApp(
    TabungKuApp(
      pengaturan: pengaturan,
    ),
  );
}

class TabungKuApp extends StatelessWidget {
  const TabungKuApp({
    super.key,
    required this.pengaturan,
  });

  final Pengaturan pengaturan;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pengaturan,
      builder: (context, child) {
        return MaterialApp(
          title: 'TabungKu',
          debugShowCheckedModeBanner: false,
          themeMode: pengaturan.modeGelap ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: pengaturan.warnaUtama,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: pengaturan.warnaUtama,
              brightness: Brightness.dark,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),
          home: ShellPage(
            pengaturan: pengaturan,
          ),
          onGenerateRoute: (settings) {
            if (settings.name != '/kegiatan') {
              return null;
            }

            final argumen = settings.arguments;

            return MaterialPageRoute<bool>(
              settings: settings,
              builder: (context) {
                return FormKegiatanPage(
                  kegiatan: argumen is Kegiatan ? argumen : null,
                );
              },
            );
          },
        );
      },
    );
  }
}
