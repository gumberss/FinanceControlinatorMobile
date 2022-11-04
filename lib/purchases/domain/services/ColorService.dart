import 'package:flutter/material.dart';

class ColorService {
  static Color colorByRemainingQuantity(int remainingQuantity) => remainingQuantity > 0
      ? Colors.deepOrangeAccent
      : remainingQuantity == 0
          ? Colors.green
          : Colors.blueAccent;
}
