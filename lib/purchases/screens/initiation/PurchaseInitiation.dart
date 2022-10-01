import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import 'package:flutter/material.dart';

import '../../domain/PurchaseList.dart';

class PurchaseInitiation extends StatelessWidget {
  final PurchaseList _purchaseList;

  PurchaseInitiation(PurchaseList purchaseList, {Key? key})
      : _purchaseList = purchaseList,
        super(key: key);

  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.startBuying +
              ": " +
              _purchaseList.name),
        ),
        backgroundColor: Colors.grey.shade200,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DefaultInput(AppLocalizations.of(context)!.whereAreYouBuying,
                TextInputType.text, _placeController,
                hintText: AppLocalizations.of(context)!.myFavoriteMarket),
            DefaultInput(
              AppLocalizations.of(context)!.whatAreYouBuying,
              TextInputType.text,
              _typeController,
              hintText: AppLocalizations.of(context)!.marketShopping,
            ),
            DefaultInput(
              AppLocalizations.of(context)!.purchaseTitle,
              TextInputType.text,
              _titleController,
              hintText: AppLocalizations.of(context)!.weeklyShop,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.arrow_forward),
          onPressed: () {},
        ));
  }
}
