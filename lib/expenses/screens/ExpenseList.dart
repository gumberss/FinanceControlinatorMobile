import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses List"),
      ),
      body: Column(
        children: [
          ExpenseListHeader(),
          ExpenseListBody()
        ],
      ),
    );
  }
}

class ExpenseListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Color.fromARGB(130, 122, 184, 241),
      height: 100,
      child: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 8, right: 8, left: 8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            OverviewCardWithMargin(),
            OverviewCardWithMargin(),
            OverviewCardWithMargin(),
          ],
        ),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8, bottom: 4),
      child: OverviewCard(),
    );
  }
}

class OverviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
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
          child: Text("data"),
        ),
    );
  }
}
