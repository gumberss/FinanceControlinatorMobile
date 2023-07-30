import 'package:finance_controlinator_mobile/purchases/domain/shopping/Shopping.dart';
import 'package:flutter/cupertino.dart';

class ShoppingSessionItem extends StatelessWidget {
  final Shopping _shopping;
  final String _userId;

  ShoppingSessionItem(this._shopping, this._userId, {Key? key});

  @override
  Widget build(BuildContext context) {
    return Text("Shopping here");
  }
}
