import 'package:finance_controlinator_mobile/purchases/domain/shopping/Shopping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../inprogress/ShoppingInProgressScreen.dart';

class ShoppingSessionItem extends StatelessWidget {
  final Shopping _shopping;
  final String _userId;

  const ShoppingSessionItem(this._shopping, this._userId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.grey.withOpacity(.7), width: 2),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.6),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(2, 2))
          ]),
      margin: const EdgeInsets.only(top: 6, bottom: 6, left: 4, right: 4),
      child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.title}: ${_shopping.title}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.place}: ${_shopping.place}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.type}: ${_shopping.type}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              settings: RouteSettings(name: ShoppingInProgressScreen.name),
              builder: (c) => ShoppingInProgressScreen(_shopping)))),
    );
  }
}
