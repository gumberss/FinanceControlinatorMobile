import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import 'package:flutter/material.dart';

import '../../domain/PurchaseList.dart';

class PurchaseInitiation extends StatefulWidget {
  final PurchaseList _purchaseList;

  final _formKey;

  PurchaseInitiation(PurchaseList purchaseList, {Key? key})
      : _purchaseList = purchaseList,
        _formKey = GlobalKey<FormState>(),
        super(key: key);

  @override
  State<PurchaseInitiation> createState() => _PurchaseInitiationState();
}

class _PurchaseInitiationState extends State<PurchaseInitiation> {
  final TextEditingController _placeController = TextEditingController();

  final TextEditingController _typeController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.startBuying +
              ": " +
              widget._purchaseList.name),
        ),
        backgroundColor: Colors.grey.shade200,
        body: Form(
          key: widget._formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DefaultInput(AppLocalizations.of(context)!.whereAreYouBuying,
                  TextInputType.text, _placeController,
                  validator: (text) => text == null || text.isEmpty
                      ? AppLocalizations.of(context)!.mustBeFilled
                      : null,
                  hintText: AppLocalizations.of(context)!.myFavoriteMarket),
              DefaultInput(
                AppLocalizations.of(context)!.whatAreYouBuying,
                TextInputType.text,
                _typeController,
                validator: (text) => text == null || text.isEmpty
                    ? AppLocalizations.of(context)!.mustBeFilled
                    : null,
                hintText: AppLocalizations.of(context)!.marketShopping,
              ),
              DefaultInput(
                AppLocalizations.of(context)!.purchaseTitle,
                TextInputType.text,
                _titleController,
                validator: (text) => text == null || text.isEmpty
                    ? AppLocalizations.of(context)!.mustBeFilled
                    : null,
                hintText: AppLocalizations.of(context)!.weeklyShop,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.arrow_forward),
          onPressed: () {
            var isValidForm =
                (widget._formKey.currentState?.validate() ?? false);
            if (!isValidForm) return;
          },
        ));
  }
}
