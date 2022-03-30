import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpenseOverview.dart';
import 'package:finance_controlinator_mobile/expenses/webclients/ExpenseWebClient.dart';
import 'package:finance_controlinator_mobile/expenses/screens/overview/ExpenseSpendBar.dart';
import 'package:flutter/cupertino.dart';
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
        children: [ExpenseListHeader(), ExpenseListBody()],
      ),
    );
  }
}

class ExpenseListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(130, 122, 184, 241),
      height: 230,
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
    // TODO: implement build
    return const Text("Body");
  }
}


