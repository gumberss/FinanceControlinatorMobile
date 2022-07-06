import 'dart:ffi';

import 'package:finance_controlinator_mobile/purchases/webclients/PurchaseListWebClient.dart';
import 'package:flutter/material.dart';
import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import '../../authentications/services/AuthorizationService.dart';
import '../../components/DefaultDialog.dart';
import '../domain/PurchaseList.dart';
import 'PurchaseListItem.dart';

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
          title: Text("[[PURCHASE_LISTS_SCREEN_TITLE]]"), //from dto
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
    return [
      DefaultInput("[[PURCHASE_LIST_INPUT]]", TextInputType.text,
          newPurchaseListNameController),
      Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: SizedBox(
              width: double.maxFinite,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      primary: Colors.green[900],
                      backgroundColor: Colors.green[100]),
                  onPressed: () async {
                    if (newPurchaseListNameController.text.isEmpty) {
                      //todo: toast error
                      return;
                    }

                    try {
                      await PurchaseListWebClient()
                          .create(newPurchaseListNameController.text);
                      listStateKey.currentState?.loadLists();
                      //todo: toast success
                      Navigator.pop(context);
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                      //todo: toast error
                    }
                  },
                  child: Text("[[CREATE_BUTTON]]"))))
    ];
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
                      return PurchaseListItem(purchaseLists![index]);
                    })));
  }
}
