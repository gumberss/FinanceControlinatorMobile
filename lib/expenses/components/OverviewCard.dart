
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  String text;
  Color? color;

  OverviewCard(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(right: 8, bottom: 4),
        child: Container(
          height: 100,
          width: 160,
          decoration: BoxDecoration(
              color: color ?? Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.6),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(2, 2), // changes position of shadow
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 16),
            child: Text(
              text,
              textAlign: TextAlign.justify,
            ),
          ),
        ));
  }
}