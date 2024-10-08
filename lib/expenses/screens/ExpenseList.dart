import 'dart:async';

import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/expenses/components/InfiniteList.dart';
import 'package:finance_controlinator_mobile/expenses/domain/Expense.dart';
import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpenseOverview.dart';
import 'package:finance_controlinator_mobile/expenses/screens/Expenses.dart';
import 'package:finance_controlinator_mobile/expenses/webclients/ExpenseWebClient.dart';
import 'package:finance_controlinator_mobile/expenses/screens/overview/ExpenseSpendBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../authentications/services/AuthorizationService.dart';
import 'overview/ExpenseBriefCards.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses List"),
      ),
      body: const Column(
        children: [
          Expanded(flex: 35, child: ExpenseListHeader()),
          Expanded(flex: 60, child: ExpenseListBody())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () => {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (c) => const ExpensesScreen()))
        },
      ),
    );
  }
}

class ExpenseListHeader extends StatelessWidget {
  const ExpenseListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue.shade100,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
        future: ExpenseOverviewWebClient().GetOverview(),
        builder: (context,
            AsyncSnapshot<HttpResponseData<ExpenseOverview>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var response = snapshot.data!;
          if (response.unauthorized()) {
            AuthorizationService.redirectToSignIn(context);
            return const Text("Unauthorized :(");
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ExpenseListHeaderCards(response.data!.briefs),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ExpenseSpendBar(response.data!.partitions),
                ),
              ],
            );
          }
        },
      ),
      ),
    );
  }
}

class ExpenseListBody extends StatelessWidget {
  const ExpenseListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                        style: const TextStyle(
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
  return await ExpenseWebClient().getPage(page, itemsCount);
}
