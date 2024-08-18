import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  final String? message;

  const Progress({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Theme.of(context).dialogBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: Text(
                message != null ? message! : 'Hang in there :D',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}