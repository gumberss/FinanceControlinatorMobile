import 'package:finance_controlinator_mobile/expenses/domain/Expense.dart';
import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpenseOverview.dart';
import 'package:finance_controlinator_mobile/expenses/webclients/ExpenseWebClient.dart';
import 'package:finance_controlinator_mobile/expenses/screens/overview/ExpenseSpendBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'overview/ExpenseBriefCards.dart';

class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses List"),
      ),
      body: Column(
        children: [
          Expanded(flex: 35, child: ExpenseListHeader()),
          Expanded(flex: 60, child: ExpenseListBody())
        ],
      ),
    );
  }
}

class ExpenseListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue.shade100,
      alignment: Alignment.topCenter,
      child: FutureBuilder(
        future: ExpenseOverviewWebClient().GetOverview(),
        builder: (context, AsyncSnapshot<ExpenseOverview> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ExpenseListHeaderCards(snapshot.data!.briefs),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ExpenseSpendBar(snapshot.data!.partitions),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ExpenseListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RefreshIndicator(
        onRefresh: () => requestItems(0),
        child: InifiniteList<Expense>(
          onRequest: requestItems,
          itemBuilder: (context, item, index) => Container(
              height: 100,
              decoration: BoxDecoration(
                  color: index % 2 == 0
                      ? Colors.lightBlue.shade50
                      : Colors.lightBlue.shade100,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.6),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(2, 2), // changes position of shadow
                    )
                  ]),
              margin:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text("Parcelas: ${item.installmentsCount}")
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("R\$ ${item.totalCost.toStringAsFixed(2)}"),
                      Text(
                          "Data da compra: ${DateFormat("dd-MM-yyyy").format(item.purchaseDate)}"),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}

Future<List<Expense>> requestItems(int itemsCount) async {
  const pageSize = 10;
  var page = (itemsCount / pageSize).ceil() + 1;
  return await ExpenseWebClient().getPage(page, pageSize);
}

typedef Future<List<T>> RequestFn<T>(int nextIndex);
typedef Widget ItemBuilder<T>(BuildContext context, T item, int index);

class InifiniteList<T> extends StatefulWidget {
  final RequestFn<T> onRequest;
  final ItemBuilder<T> itemBuilder;

  const InifiniteList(
      {Key? key, required this.onRequest, required this.itemBuilder})
      : super(key: key);

  @override
  _InifiniteListState<T> createState() => _InifiniteListState<T>();
}

class _InifiniteListState<T> extends State<InifiniteList<T>> {
  List<T> items = [];
  bool end = false;

  _getMoreItems() async {
    final moreItems = await widget.onRequest(items.length);
    if (!mounted) return;

    if (moreItems.isEmpty) {
      setState(() => end = true);
      return;
    }
    setState(() => items = [...items, ...moreItems]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < items.length) {
          return widget.itemBuilder(context, items[index], index);
        } else if (index == items.length && end) {
          return const Center(child: Text('End of list'));
        } else {
          _getMoreItems();
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
      itemCount: items.length + 1,
    );
  }
}
