import 'package:finance_controlinator_mobile/purchases/webclients/PurchaseListWebClient.dart';
import 'package:flutter/material.dart';
import 'package:finance_controlinator_mobile/components/DefaultInput.dart';

import '../../authentications/services/AuthorizationService.dart';
import '../../components/DefaultDialog.dart';
import '../../components/HttpClient/HttpResponseData.dart';
import '../../expenses/components/InfiniteList.dart';
import '../domain/PurchaseList.dart';

class PurchasesListsScreen extends StatelessWidget {
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
        body: PurchaseLists(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add),
          onPressed: () =>
          {
            DefaultDialog().showDialog(context, NewPurchaseListDialog(context))
          },
        ));
  }

  List<Widget> NewPurchaseListDialog(BuildContext context) {
    return [
      DefaultInput("[[PURCHASE_LIST_INPUT]]", TextInputType.text,
          TextEditingController()),
      Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 8),
          child: SizedBox(
              width: double.maxFinite,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      primary: Colors.green[900],
                      backgroundColor: Colors.green[100]),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("[[CREATE_BUTTON]]"))))
    ];
  }
}

class PurchaseLists extends StatefulWidget {
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
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                itemCount: purchaseLists?.length,
                itemBuilder: (context, index) {
                  if (purchaseLists == null) return Text("");
                  return Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.lightGreen.shade100,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.6),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(
                                  2, 2), // changes position of shadow
                            )
                          ]),
                      margin: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 4, right: 4),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                purchaseLists![index].name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )
                            ],
                          ),
                        ],
                      ));
                })));
  }
}
