import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorModel extends ChangeNotifier {
  final List<Color> colors = [
    Colors.red.shade500,
    Colors.blue.shade400,
    Colors.green.shade400,
    Colors.yellow,
    Colors.purple.shade800,
  ];

  int _selectedColorIndex;

  ColorModel(this._selectedColorIndex);

  Color get selectedColor => colors[_selectedColorIndex];

  void setColor(int index) async {
    _selectedColorIndex = index;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedColor', index);
  }
}

