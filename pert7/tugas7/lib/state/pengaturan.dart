import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pengaturan extends ChangeNotifier {
  static const int targetAwal = 20000;

  static const List<String> pilihanWarna = [
    'Hijau',
    'Biru',
    'Ungu',
  ];

  static const String _kunciTarget = 'target_tabungan';
  static const String _kunciGelap = 'mode_gelap';
  static const String _kunciWarna = 'warna_tema';

  SharedPreferences? _preferensi;

  int _target = targetAwal;
  bool _modeGelap = false;
  String _warna = 'Hijau';

  int get target => _target;
  bool get modeGelap => _modeGelap;
  String get warna => _warna;

  Color get warnaUtama {
    switch (_warna) {
      case 'Biru':
        return Colors.blue;
      case 'Ungu':
        return Colors.deepPurple;
      default:
        return Colors.teal;
    }
  }

  Future<void> muat() async {
    _preferensi = await SharedPreferences.getInstance();

    _target = _preferensi!.getInt(_kunciTarget) ?? targetAwal;

    _modeGelap = _preferensi!.getBool(_kunciGelap) ?? false;

    final warnaTersimpan = _preferensi!.getString(_kunciWarna) ?? 'Hijau';

    _warna = pilihanWarna.contains(warnaTersimpan) ? warnaTersimpan : 'Hijau';

    notifyListeners();
  }

  Future<void> aturTarget(int nilai) async {
    if (nilai == _target) return;

    _target = nilai;
    notifyListeners();

    await _preferensi!.setInt(_kunciTarget, nilai);
  }

  Future<void> aturModeGelap(bool aktif) async {
    if (aktif == _modeGelap) return;

    _modeGelap = aktif;
    notifyListeners();

    await _preferensi!.setBool(_kunciGelap, aktif);
  }

  Future<void> aturWarna(String warnaBaru) async {
    if (!pilihanWarna.contains(warnaBaru)) return;
    if (warnaBaru == _warna) return;

    _warna = warnaBaru;
    notifyListeners();

    await _preferensi!.setString(
      _kunciWarna,
      warnaBaru,
    );
  }
}
