import 'dart:async';

import 'package:flutter/material.dart';

import '../screens/SignIn.dart';

class AuthorizationService {
  static void redirectToSignIn(BuildContext context){
    @override
    void run() {
      scheduleMicrotask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      });
    }

    run();
  }
}