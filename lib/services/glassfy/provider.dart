import 'package:flutter/material.dart';

class GlassfyProvider extends ChangeNotifier {
  bool _isPremium = false;

  int coins = 0;

  bool get isPremium => _isPremium;

  set isPremium(bool isPremium) {
    _isPremium = isPremium;

    notifyListeners();
  }

  void add10Coins() {
    coins += 10;

    notifyListeners();
  }
}
