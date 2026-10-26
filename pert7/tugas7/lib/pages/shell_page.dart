import 'package:flutter/material.dart';

import '../state/pengaturan.dart';
import 'beranda_page.dart';
import 'laporan_page.dart';
import 'pengaturan_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({
    super.key,
    required this.pengaturan,
  });

  final Pengaturan pengaturan;

  @override
  State<ShellPage> createState() {
    return _ShellPageState();
  }
}

class _ShellPageState extends State<ShellPage> {
  int _tabAktif = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tabAktif,
        children: [
          BerandaPage(
            pengaturan: widget.pengaturan,
          ),
          LaporanPage(
            pengaturan: widget.pengaturan,
          ),
          PengaturanPage(
            pengaturan: widget.pengaturan,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabAktif,
        onDestinationSelected: (index) {
          setState(() {
            _tabAktif = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.today_outlined,
            ),
            selectedIcon: Icon(
              Icons.today,
            ),
            label: 'Hari Ini',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.bar_chart_outlined,
            ),
            selectedIcon: Icon(
              Icons.bar_chart,
            ),
            label: 'Laporan',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
            ),
            selectedIcon: Icon(
              Icons.settings,
            ),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
