import 'package:finance_controlinator_mobile/expenses/components/InfiniteList.dart';
import 'package:finance_controlinator_mobile/expenses/domain/Expense.dart';
import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpenseOverview.dart';
import 'package:finance_controlinator_mobile/expenses/screens/Expenses.dart';
import 'package:finance_controlinator_mobile/expenses/webclients/ExpenseWebClient.dart';
import 'package:finance_controlinator_mobile/expenses/screens/overview/ExpenseSpendBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
        onPressed: () => {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => ExpensesScreen()))
        },
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
      child: Padding(padding: EdgeInsets.all(8),
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
      ),),
    );
  }
}

class ExpenseListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RefreshIndicator(
        onRefresh: () => requestItems(1, 10),
        child: InifiniteList<Expense>(
          onRequest: requestItems,
          itensPerPage: 10,
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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

Future<List<Expense>> requestItems(int page, int itemsCount) async {
  //const pageSize = 10;
  //var page = (itemsCount / pageSize).ceil() + 1;
  return await ExpenseWebClient().getPage(page, itemsCount);
}


