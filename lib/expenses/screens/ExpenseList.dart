import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpenseOverview.dart';
import 'package:finance_controlinator_mobile/expenses/webclients/ExpenseWebClient.dart';
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
      height: 200,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 8, right: 8, left: 8),
        child: Column(
          children: [
            Expanded(
              child: ExpenseListHeaderCards(),
            ),
            ExpenseListHeaderBar()
          ],
        ),
      ),
    );
  }
}

class ExpenseListHeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 40,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6))),
                )),
            Expanded(
                flex: 25,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                  ),
                )),
            Expanded(
                flex: 30,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                  ),
                )),
            Expanded(
                flex: 5,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6))),
                ))
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Text("Mercado:"),
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Text("Contas:"),
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Text("Lazer:"),
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Text("Saúde:"),
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Text("Outros:"),
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              )
            ],
          ),
        ),
        Row(
          children: [

          ],
        )
      ],
    );
  }
}

class ExpenseListHeaderCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ExpenseOverviewWebClient().GetOverview(),
      builder: (context, AsyncSnapshot<List<ExpenseOverview>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext cxt, int index) {
            return OverviewCardWithMargin(snapshot.data![index].text);
          },
        );
      },
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
