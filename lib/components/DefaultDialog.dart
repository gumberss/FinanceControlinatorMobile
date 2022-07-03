import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultDialog {
  showDialog(BuildContext context, List<Widget> content, {double? height}) {
    height ??= 180;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                    height: height,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(10),
                                topRight: const Radius.circular(10))),
                        child: Column(children: content))),
              )
            ],
          );
        });
  }
}
