import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/shopping/Shopping.dart';

class ShoppingInProgressScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Shopping _shopping;

  ShoppingInProgressScreen(this._shopping, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_shopping.title),
        ),
        backgroundColor: Colors.grey.shade200,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.arrow_forward),
          onPressed: () async {},
        ));
  }
}
