import 'package:finance_controlinator_mobile/purchases/webclients/UserWebClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finance_controlinator_mobile/purchases/webclients/PurchaseListWebClient.dart';
import 'package:flutter/material.dart';
import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../authentications/services/AuthorizationService.dart';
import '../../../components/DefaultDialog.dart';
import '../../../components/toast.dart';
import '../../../components/userService.dart';
import '../../domain/PurchaseList.dart';
import 'PurchaseListItem.dart';

List<Widget> TextInputActionDialog(BuildContext context, String text,
    TextEditingController controller, VoidCallback action,
    {String? buttonText, String? initialValue}) {
  return [
    DefaultInput(text, TextInputType.text, controller),
    Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: SizedBox(
            width: double.maxFinite,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: Colors.green[900], backgroundColor: Colors.white),
                onPressed: () async {
                  if (controller.text.isEmpty) {
                    //todo: toast error
                    return;
                  }

                  try {
                    //todo: this should be a future
                    action();
                    //todo: toast success
                    controller.clear();
                    Navigator.pop(context);
                  } on Exception catch (e) {
                    debugPrint(e.toString());
                    //todo: toast error
                  }
                },
                child:
                    Text(buttonText ?? AppLocalizations.of(context)!.create))))
  ];
}

class PurchasesListsScreen extends StatefulWidget {
  FToast toast = FToast();

  @override
  State<PurchasesListsScreen> createState() => _PurchasesListsScreenState();
}

class _PurchasesListsScreenState extends State<PurchasesListsScreen> {
  final listStateKey = GlobalKey<_PurchaseListsState>();
  String? _nickname;

  @override
  void initState() {
    super.initState();
    _loadNickname();
  }

  Future<void> _loadNickname() async {
    final nickname = await UserSharedPreferencies().userNickname;
    setState(() {
      _nickname = nickname ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    //if (response.unauthorized()) {
    //AuthorizationService.redirectToSignIn(context);
    // return Text("Unauthorized :(");
    //       } else {

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.purchaseListScreenTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Nickname Setter',
              onPressed: () {
                DefaultDialog().showDialog(context, NiknameDialog(context));
              },
            ),
          ],
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

  TextEditingController nicknameController = TextEditingController();

  List<Widget> NiknameDialog(BuildContext context) {
    nicknameController.text = _nickname!;

    return TextInputActionDialog(
      context,
      AppLocalizations.of(context)!.nickname,
      nicknameController,
      () async {
        var result = await UserWebClient().setNickname(nicknameController.text);
        if (result.success()) {
          DefaultToaster.toastSuccess(widget.toast,
              message: AppLocalizations.of(context)!.nicknameSetted);
          setState(() => _nickname = result.data!.nickname!);
          await UserSharedPreferencies()
              .storeUserNickname(nicknameController.text);
        } else {
          if (result.statusCode == 400 &&
              result.errorMessage == "[[NICKNAME_ALREADY_USED]]") {
            DefaultToaster.toastError(widget.toast,
                message:
                    AppLocalizations.of(context)!.nicknameAlreadyInUseError);
          } else if (result.statusCode == 400 &&
              result.errorMessage == "[[INVALID_NICKNAME]]") {
            DefaultToaster.toastError(widget.toast,
                message: AppLocalizations.of(context)!.invalidNickname);
          } else {
            DefaultToaster.toastError(widget.toast,
                message: AppLocalizations.of(context)!.nicknameServerError);
          }
          debugPrint(result.errorMessage);
        }
      },
      buttonText: AppLocalizations.of(context)!.send,
    );
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
