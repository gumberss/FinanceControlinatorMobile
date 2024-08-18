import 'package:finance_controlinator_mobile/expenses/screens/ExpenseList.dart';
import 'package:finance_controlinator_mobile/purchases/screens/creation/PurchasesLists.dart';
import 'package:flutter/material.dart';

import '../invoices/screens/InvoicesScreen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Finance Controlinator"),
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Colls(),
          //  Carousel()
          ],
        ));
  }
}

class Carousel extends StatelessWidget {
  const Carousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Card(Icons.account_balance_wallet, "Account", () => {}),
          Card(Icons.money_off, "Expenses", () => {}),
          Card(Icons.list_alt, "Invoices", () => {}),
          Card(Icons.payment, "Payments", () => {}),
          Card(Icons.save, "Piggy Banks", () => {}),
        ],
      ),
    );
  }
}

class Colls extends StatelessWidget {
  const Colls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Card(Icons.account_balance_wallet, "Account", () => {}),
            Card(Icons.money_off, "Expenses", () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => const ExpenseList()));
            }),
            Card(Icons.list_alt, "Invoices", () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) => const InvoicesScreen()))),
          ],
        ),
        Column(
          children: [
            Card(Icons.payment, "Payment", () => {}),
            Card(Icons.save, "Piggy Banks", () => {}),
            Card(Icons.shopping_cart, "Purchases", () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) => PurchasesListsScreen()))),
          ],
        ),
      ],
    ));
  }
}

class Card extends StatelessWidget {
  IconData icon;
  String title;
  Function onTap;

  Card(this.icon, this.title, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(1, 0), // changes position of shadow
            )
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary,
          child: InkWell(
            onTap: () => onTap(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
