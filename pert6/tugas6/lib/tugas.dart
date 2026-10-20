import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// PENGATURAN TEMA

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

const pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

// PENYIMPANAN PENGATURAN TEMA

Future<void> simpanModeGelap(bool gelap) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('mode_gelap', gelap);
}

Future<void> simpanWarnaTema(Color warna) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('warna_tema', warna.value);
}

Future<void> muatPengaturanTema() async {
  final prefs = await SharedPreferences.getInstance();

  final gelap = prefs.getBool('mode_gelap') ?? false;
  final warna = prefs.getInt('warna_tema');

  themeMode.value =
  gelap ? ThemeMode.dark : ThemeMode.light;

  if (warna != null) {
    seedColor.value = Color(warna);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await muatPengaturanTema();
  runApp(const MyApp());
}

// MATERIAL APP DAN NAMED ROUTES

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Katalog Interaktif',
          debugShowCheckedModeBanner: false,
          theme: buatTema(
            seedColor.value,
            Brightness.light,
          ),
          darkTheme: buatTema(
            seedColor.value,
            Brightness.dark,
          ),
          themeMode: themeMode.value,
          initialRoute: '/',
          routes: {
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final item = settings.arguments as Item;

              return MaterialPageRoute(
                builder: (_) => DetailPage(item: item),
                settings: settings,
              );
            }
            return null;
          },
        );
      },
    );
  }
}

// MODEL DATA KATALOG
// MENGGUNAKAN CONTOH ITEM DARI BAGIAN B MODUL

class Item {
  final String nama;
  final IconData ikon;

  const Item(this.nama, this.ikon);
}

const daftarItem = [
  Item('Flutter', Icons.flutter_dash),
  Item('Musik', Icons.music_note),
  Item('Kamera', Icons.camera_alt),
  Item('Peta', Icons.map),
];

// TAB BERANDA
// ANIMASI IMPLISIT DAN EKSPLISIT

class BerandaTab extends StatefulWidget {
  const BerandaTab({super.key});

  @override
  State<BerandaTab> createState() => _BerandaTabState();
}

class _BerandaTabState extends State<BerandaTab>
    with SingleTickerProviderStateMixin {
  bool _besar = false;
  late final AnimationController _putar;

  @override
  void initState() {
    super.initState();

    _putar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _putar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Katalog Interaktif',
          style: tema.textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),

        // ANIMASI IMPLISIT
        Text(
          '1. AnimatedContainer',
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _besar ? 200 : 100,
            height: 100,
            decoration: BoxDecoration(
              color: _besar
                  ? warna.primary
                  : warna.tertiary,
              borderRadius: BorderRadius.circular(
                _besar ? 50 : 8,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() => _besar = !_besar);
          },
          child: const Text('Ubah bentuk'),
        ),
        const Divider(),

        // ANIMASI EKSPLISIT
        Text(
          '2. AnimationController',
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Center(
          child: RotationTransition(
            turns: _putar,
            child: Icon(
              Icons.settings,
              size: 64,
              color: warna.primary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_putar.isAnimating) {
              _putar.stop();
            } else {
              _putar.repeat();
            }
            setState(() {});
          },
          child: Text(
            _putar.isAnimating ? 'Berhenti' : 'Putar',
          ),
        ),
      ],
    );
  }
}

// TAB KATALOG

class KatalogTab extends StatelessWidget {
  const KatalogTab({super.key});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return ListView.builder(
      itemCount: daftarItem.length,
      itemBuilder: (context, i) {
        final item = daftarItem[i];

        return ListTile(
          leading: Hero(
            tag: 'ikon-${item.nama}',
            child: CircleAvatar(
              backgroundColor: warna.primaryContainer,
              child: Icon(
                item.ikon,
                color: warna.onPrimaryContainer,
              ),
            ),
          ),
          title: Text(item.nama),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: item,
            );
          },
        );
      },
    );
  }
}

// HALAMAN DETAIL DENGAN HERO

class DetailPage extends StatelessWidget {
  final Item item;

  const DetailPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.nama),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'ikon-${item.nama}',
              child: CircleAvatar(
                radius: 64,
                backgroundColor: warna.primaryContainer,
                child: Icon(
                  item.ikon,
                  size: 64,
                  color: warna.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.nama,
              style: tema.textTheme.headlineMedium,
            ),
            Text(
              'Detail untuk ${item.nama}',
              style: tema.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// TAB PENGATURAN TEMA

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Mode gelap'),
              value: themeMode.value == ThemeMode.dark,
              onChanged: (v) {
                themeMode.value =
                v ? ThemeMode.dark : ThemeMode.light;

                simpanModeGelap(v);
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Warna tema',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                for (final c in pilihanWarna)
                  GestureDetector(
                    onTap: () {
                      seedColor.value = c;
                      simpanWarnaTema(c);
                    },
                    child: CircleAvatar(
                      backgroundColor: c,
                      child: seedColor.value == c
                          ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

// NAVIGASI TIGA TAB

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  static const _halaman = [
    BerandaTab(),
    KatalogTab(),
    PengaturanTab(),
  ];

  static const _judul = [
    'Beranda',
    'Katalog',
    'Pengaturan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_judul[_index]),
      ),
      body: IndexedStack(
        index: _index,
        children: _halaman,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          setState(() => _index = i);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}