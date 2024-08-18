import 'package:finance_controlinator_mobile/purchases/domain/PurchaseList.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';import '../../../../authentications/services/AuthorizationService.dart';


import '../../../../components/JwtService.dart';
import '../../../domain/shopping/Shopping.dart';
import '../../../webclients/shopping/ShoppingSessionWebClient.dart';
import '../initiation/ShoppingInitiation.dart';
import 'ShoppingSessionItem.dart';

class ShoppingSessionsScreen extends StatefulWidget {
  final PurchaseList _purchaseList;
  static const String name = "ShoppingSessionsScreen";

  const ShoppingSessionsScreen(this._purchaseList, {super.key});

  @override
  State<ShoppingSessionsScreen> createState() => _ShoppingSessionsScreenState();
}

class _ShoppingSessionsScreenState extends State<ShoppingSessionsScreen> {
  List<Shopping>? activeShopping;
  bool starting = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    initiate();
  }


  Future initiate() async {
    setState(() {
      starting = true;
    });

    await loadSessions();
    await loadUserId();

    setState(() {
      starting = false;
    });
  }

  Future loadUserId() async {
    var userId = await JwtService().userId;

    setState(() {
      this.userId = userId;
    });
  }

  Future loadSessions() async {

    var response = await ShoppingSessionWebClient().active(widget._purchaseList.id!);

    if (response.unauthorized()) {
      AuthorizationService.redirectToSignIn(context);
      return;
    }

    if (response.serverError()) {
      setState(() {
        activeShopping = List<Shopping>.empty(growable: false);
      });
      //todo: toast error
      return;
    }
    setState(() {
      activeShopping = response.data!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.shoppingInProgress),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Lists',
                onPressed: () {
                  initiate();
                },
              ),
            ]),
        backgroundColor: Colors.grey.shade200,
        body: buildList(),
        floatingActionButton: initShoppingButton(context, widget._purchaseList));
  }

  Widget buildList(){
    return SizedBox(
        width: double.infinity,
        child: RefreshIndicator(
            onRefresh: loadSessions,
            child: starting
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                itemCount: activeShopping?.length,
                itemBuilder: (context, index) {
                  if (activeShopping == null) return const Text("");
                  return ShoppingSessionItem(
                      activeShopping![index], userId!);
                })));
  }

  FloatingActionButton initShoppingButton(
      BuildContext context, PurchaseList list) {
    return FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      child: const Icon(Icons.add),
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          settings: const RouteSettings(name: ShoppingInitiationScreen.name),
          builder: (c) => ShoppingInitiationScreen(list))),
    );
  }
}
