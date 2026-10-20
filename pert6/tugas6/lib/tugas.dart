import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

const List<Color> pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

Future<void> muatTema() async {
  final prefs = await SharedPreferences.getInstance();
  final gelap = prefs.getBool('gelap') ?? false;
  final idx = prefs.getInt('warna') ?? 0;
  themeMode.value = gelap ? ThemeMode.dark : ThemeMode.light;
  seedColor.value = pilihanWarna[idx];
}

Future<void> simpanTema(bool gelap, Color warna) async {
  themeMode.value = gelap ? ThemeMode.dark : ThemeMode.light;
  seedColor.value = warna;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('gelap', gelap);
  await prefs.setInt('warna', pilihanWarna.indexOf(warna));
}

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await muatTema();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Galeri Wisata',
          debugShowCheckedModeBanner: false,
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
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

class Item {
  final String nama;
  final String lokasi;
  final String deskripsi;
  final IconData ikon;
  const Item(this.nama, this.lokasi, this.deskripsi, this.ikon);
}

const daftarItem = [
  Item('Candi Borobudur', 'Magelang', 'Candi Buddha terbesar di dunia.', Icons.account_balance),
  Item('Raja Ampat', 'Papua Barat', 'Kepulauan karst dan wisata bahari.', Icons.water),
  Item('Gunung Bromo', 'Jawa Timur', 'Kaldera pasir dan matahari terbit.', Icons.terrain),
  Item('Danau Toba', 'Sumatera Utara', 'Danau vulkanik dengan Pulau Samosir.', Icons.landscape),
];

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  static const _halaman = [BerandaTab(), AnimasiTab(), PengaturanTab()];
  static const _judul = ['Katalog Wisata', 'Animasi', 'Pengaturan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_index])),
      body: IndexedStack(index: _index, children: _halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.animation),
            label: 'Animasi',
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

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return ListView.builder(
      itemCount: daftarItem.length,
      itemBuilder: (context, i) {
        final item = daftarItem[i];
        return ListTile(
          leading: Hero(
            tag: 'ikon-${item.nama}',
            child: CircleAvatar(
              backgroundColor: warna.primaryContainer,
              child: Icon(item.ikon, color: warna.onPrimaryContainer),
            ),
          ),
          title: Text(item.nama, style: tema.textTheme.titleMedium),
          subtitle: Text(item.lokasi, style: tema.textTheme.bodySmall),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final Item item;
  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(item.nama)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'ikon-${item.nama}',
              child: CircleAvatar(
                radius: 64,
                backgroundColor: warna.primaryContainer,
                child: Icon(item.ikon, size: 64, color: warna.onPrimaryContainer),
              ),
            ),
            const SizedBox(height: 16),
            Text(item.nama, style: tema.textTheme.headlineMedium),
            Text(item.lokasi, style: tema.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(item.deskripsi, style: tema.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class AnimasiTab extends StatefulWidget {
  const AnimasiTab({super.key});

  @override
  State<AnimasiTab> createState() => _AnimasiTabState();
}

class _AnimasiTabState extends State<AnimasiTab>
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
        Text('1. AnimatedContainer (Implisit)', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _besar ? 200 : 100,
            height: 100,
            decoration: BoxDecoration(
              color: _besar ? warna.primary : warna.tertiary,
              borderRadius: BorderRadius.circular(_besar ? 50 : 8),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _besar = !_besar),
          child: const Text('Ubah bentuk'),
        ),
        const Divider(),
        Text('2. AnimationController (Eksplisit)', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: RotationTransition(
            turns: _putar,
            child: Icon(Icons.explore, size: 64, color: warna.primary),
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
          child: Text(_putar.isAnimating ? 'Berhenti' : 'Putar'),
        ),
      ],
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        final gelap = themeMode.value == ThemeMode.dark;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Mode gelap'),
              value: gelap,
              onChanged: (v) => simpanTema(v, seedColor.value),
            ),
            const SizedBox(height: 8),
            Text('Warna tema', style: tema.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                for (final c in pilihanWarna)
                  GestureDetector(
                    onTap: () => simpanTema(gelap, c),
                    child: CircleAvatar(
                      backgroundColor: c,
                      child: seedColor.value == c
                          ? Icon(Icons.check, color: warna.onPrimary)
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