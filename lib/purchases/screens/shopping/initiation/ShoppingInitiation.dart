import 'package:finance_controlinator_mobile/purchases/domain/shopping/ShoppingInitiation.dart';
import 'package:finance_controlinator_mobile/purchases/screens/shopping/inprogress/ShoppingInProgressScreen.dart';
import 'package:finance_controlinator_mobile/purchases/webclients/shopping/ShoppingInitiationWebClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

import '../../../../components/Locator.dart';
import '../../../domain/PurchaseList.dart';

class ShoppingInitiationScreen extends StatefulWidget {
  final PurchaseList _purchaseList;
  final _formKey;

  ShoppingInitiationScreen(PurchaseList purchaseList, {Key? key})
      : _purchaseList = purchaseList,
        _formKey = GlobalKey<FormState>(),
        super(key: key);

  @override
  State<ShoppingInitiationScreen> createState() =>
      _ShoppingInitiationScreenState();
}

class _ShoppingInitiationScreenState extends State<ShoppingInitiationScreen> {
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final String shoppingInitiationId = const Uuid().v4();

  Future<Timer>? _positionTimerFuture;
  Timer? _positionTimer;
  Position? _position;

  @override
  void initState() {
    super.initState();
    _positionTimerFuture = refreshPositionPeriodic(refreshNowToo: true)
        .then((timer) => _positionTimer = timer);
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("que isso");
    _positionTimerFuture?.then((value) => value.cancel());
    _positionTimer?.cancel();
  }

  //https://github.com/Baseflow/flutter-geolocator/issues/320#issuecomment-908296930
  Future<Timer> refreshPositionPeriodic({bool refreshNowToo = false}) async {
    if (refreshNowToo) {
      _position = await getPosition();
    }
    return Timer.periodic(const Duration(seconds: 30), (timer) async {
      _position = await getPosition();
      debugPrint(timer.tick.toString());
    });
  }

  Future<Position?> getPosition() async {
    var result = await Locator().getPosition();
    if (result.isSuccess) {
      return result.value;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ;
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
          onPressed: () async {
            var isValidForm =
                (widget._formKey.currentState?.validate() ?? false);

            if (!isValidForm) return;

            var position = _position;
            if (position == null) {
              var positionResult = await Locator().getPosition();
              if (positionResult.isFailure) {
                //todo: show error
                debugPrint(positionResult.error?.message);
                return;
              }

              position = positionResult.value;
            }

            debugPrint(position?.latitude.toString());
            var shoppingInitiation = ShoppingInitiation(
                shoppingInitiationId,
                _placeController.text,
                _typeController.text,
                _titleController.text,
                widget._purchaseList.id,
                position?.latitude,
                position?.longitude);

            //todo progress
            var initResult =
                await ShoppingInitiationWebClient().init(shoppingInitiation);

            if (initResult.success()) {
              _positionTimer?.cancel();
              var shopping = initResult.data!;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) => ShoppingInProgressScreen(shopping)));
            } else {
              //todo: show error
            }
          },
        ));
  }
}
