import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpenseBrief.dart';
import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpenseOverview.dart';
import 'package:finance_controlinator_mobile/expenses/webclients/ExpenseWebClient.dart';
import 'package:finance_controlinator_mobile/expenses/screens/overview/ExpenseOverviewSpendBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses List"),
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
      color: Color.fromARGB(130, 122, 184, 241),
      height: 230,
      alignment: Alignment.topCenter,
      child: FutureBuilder(
        future: ExpenseOverviewWebClient().GetOverview(),
        builder: (context, AsyncSnapshot<ExpenseOverview> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: ExpenseListHeaderCards(snapshot.data!.briefs),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: ExpenseOverviewSpendBar(snapshot.data!.partitions),
              ),
            ],
          );
        },
      ),
    );
  }
}


class ExpenseListHeaderCards extends StatelessWidget {
  List<ExpenseBrief> expenseBriefs;

  ExpenseListHeaderCards(this.expenseBriefs);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children:
            expenseBriefs.map((e) => OverviewCardWithMargin(e.text)).toList(),
      ),
    );
  }
}

class ExpenseListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("Body");
  }
}

class OverviewCardWithMargin extends StatelessWidget {
  String text;

  OverviewCardWithMargin(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(right: 8, bottom: 4),
      child: OverviewCard(text),
    );
  }
}

class OverviewCard extends StatelessWidget {
  String text;

  OverviewCard(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 160,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.6),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(2, 2), // changes position of shadow
            )
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 16),
        child: Text(
          this.text,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
