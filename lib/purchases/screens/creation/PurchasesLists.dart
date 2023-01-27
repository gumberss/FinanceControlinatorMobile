import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finance_controlinator_mobile/purchases/webclients/PurchaseListWebClient.dart';
import 'package:flutter/material.dart';
import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import '../../../authentications/services/AuthorizationService.dart';
import '../../../components/DefaultDialog.dart';
import '../../domain/PurchaseList.dart';
import 'PurchaseListItem.dart';

List<Widget> TextInputActionDialog(BuildContext context, String text,
    TextEditingController controller, VoidCallback action) {
  return [
    DefaultInput(text, TextInputType.text, controller),
    Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: SizedBox(
            width: double.maxFinite,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: Colors.green[900],
                    backgroundColor: Colors.white),
                onPressed: () async {
                  if (controller.text.isEmpty) {
                    //todo: toast error
                    return;
                  }

                  try {
                    action();
                    //todo: toast success
                    controller.clear();
                    Navigator.pop(context);
                  } on Exception catch (e) {
                    debugPrint(e.toString());
                    //todo: toast error
                  }
                },
                child: Text(AppLocalizations.of(context)!.create))))
  ];
}

class PurchasesListsScreen extends StatelessWidget {
  final listStateKey = GlobalKey<_PurchaseListsState>();

  @override
  Widget build(BuildContext context) {
    //if (response.unauthorized()) {
    //AuthorizationService.redirectToSignIn(context);
    // return Text("Unauthorized :(");
    //       } else {

    return Scaffold(
        appBar: AppBar(
          title: Text(
              AppLocalizations.of(context)!.purchaseListScreenTitle), //from dto
        ),
        body: PurchaseLists(listStateKey),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add),
          onPressed: () => {
            DefaultDialog().showDialog(context, NewPurchaseListDialog(context))
          },
        ));
  }

  TextEditingController newPurchaseListNameController = TextEditingController();

  List<Widget> NewPurchaseListDialog(BuildContext context) {
    return TextInputActionDialog(
        context,
        AppLocalizations.of(context)!.purchaseListName,
        newPurchaseListNameController, () async {
      var result = await PurchaseListWebClient()
          .create(newPurchaseListNameController.text);
      if (result.success()) {
        listStateKey.currentState?.loadLists();
      } else {
        debugPrint(result.errorMessage);
      }
    });
  }
}

class PurchaseLists extends StatefulWidget {
  PurchaseLists(Key? key) : super(key: key);

  @override
  State<PurchaseLists> createState() => _PurchaseListsState();
}

class _PurchaseListsState extends State<PurchaseLists> {
  List<PurchaseList>? purchaseLists;
  bool starting = true;

  @override
  void initState() {
    super.initState();
    loadLists();
  }

  Future loadLists() async {
    var response = await PurchaseListWebClient().getAll();

    if (response.unauthorized()) {
      AuthorizationService.redirectToSignIn(context);
      return;
    }

    if (response.serverError()) {
      setState(() {
        purchaseLists = List<PurchaseList>.empty(growable: false);
        starting = false;
      });
      //todo: toast error
      return;
    }

    setState(() {
      purchaseLists = response.data!;
      starting = false;
    });
  }

  TextEditingController editPurchaseListNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: RefreshIndicator(
            onRefresh: loadLists,
            child: starting
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: purchaseLists?.length,
                    itemBuilder: (context, index) {
                      if (purchaseLists == null) return const Text("");
                      return PurchaseListItem(purchaseLists![index], loadLists);
                    })));
  }
}
