import 'package:finance_controlinator_mobile/purchases/screens/management/PurchaseListManagementScreen.dart';
import 'package:finance_controlinator_mobile/purchases/webclients/PurchaseListWebClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/DefaultDialog.dart';
import '../../../components/toast.dart';
import '../../domain/PurchaseList.dart';
import 'PurchasesLists.dart';

class PurchaseListItem extends StatelessWidget {
  final PurchaseList _purchaseList;
  final Function _onChangeHappen;
  final FToast toast;
  final String _userId;

  PurchaseListItem(PurchaseList purchaseList, userId, Function onChangeHappen,
      {Key? key})
      : _purchaseList = purchaseList,
        _userId = userId,
        _onChangeHappen = onChangeHappen,
        toast = FToast(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
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
          child: Slidable(
            startActionPane: slideLeftBackground(context),
            endActionPane: slideRightBackground(context),
            key: Key(_purchaseList.name),
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
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          _purchaseList.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
                _purchaseList.inProgress
                    ? const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.blueAccent,
                        ))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              settings: RouteSettings(name: PurchaseListManagementScreen.name),
              builder: (c) => PurchaseListManagementScreen(_purchaseList)))),
    );
  }

  ActionPane slideLeftBackground(BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            await PurchaseListWebClient().disable(_purchaseList.id!);
            _onChangeHappen();
          },
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          icon: Icons.delete,
        )
      ],
    );
  }

  ActionPane slideRightBackground(BuildContext context) {
    var actions = [
      SlidableAction(
        onPressed: (ctx) {
          DefaultDialog().showDialog(
              context, EditPurchaseListDialog(context, _purchaseList));
        },
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        icon: Icons.edit,
      )
    ];

    if (_purchaseList.userId == _userId) {
      actions.add(SlidableAction(
        onPressed: (ctx) {
          DefaultDialog()
              .showDialog(context, shareDialog(context, _purchaseList));
        },
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        icon: Icons.link,
      ));
    }

    return ActionPane(
      motion: const ScrollMotion(),
      children: actions,
    );
  }

  TextEditingController editPurchaseListNameController =
      TextEditingController();

  List<Widget> EditPurchaseListDialog(
      BuildContext context, PurchaseList purchaseList) {
    editPurchaseListNameController.text = purchaseList.name;
    return TextInputActionDialog(
        context,
        AppLocalizations.of(context)!.purchaseListName,
        editPurchaseListNameController, () async {
      if (purchaseList.name != editPurchaseListNameController.text) {
        purchaseList.name = editPurchaseListNameController.text;
        await PurchaseListWebClient().edit(purchaseList);
        _onChangeHappen();
      }
    });
  }

  TextEditingController shareToNicknameController = TextEditingController();

  List<Widget> shareDialog(BuildContext context, PurchaseList purchaseList) {
    var listSharedText = AppLocalizations.of(context)!.listShared;
    var errorMessage = AppLocalizations.of(context)!.shareListServerError;
    return TextInputActionDialog(
      context,
      AppLocalizations.of(context)!.shareWith,
      shareToNicknameController,
      () async {
        var result = await PurchaseListWebClient()
            .shareList(purchaseList.id!, shareToNicknameController.text);
        if (result.success()) {
          DefaultToaster.toastSuccess(toast, message: listSharedText);
        } else {
          DefaultToaster.toastError(toast, message: errorMessage);
          debugPrint(result.errorMessage);
        }
      },
      buttonText: AppLocalizations.of(context)!.share,
    );
  }
}
