import 'package:flutter/material.dart';

class DefaultDialog {
  showDialog(BuildContext context, List<Widget> content,
      {double? height, MainAxisAlignment? mainAlignment}) {
    height ??= 180;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: mainAlignment ?? MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                    height: height,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Column(children: content))),
              )
            ],
          );
        });
  }

  Future<T?> showDialogScreen<T>(BuildContext context, Widget content,
      {double? height, MainAxisAlignment? mainAlignment}) {
    height ??= 180;
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: mainAlignment ?? MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                    height: height,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child:content)),
              )
            ],
          );
        });
  }
}
