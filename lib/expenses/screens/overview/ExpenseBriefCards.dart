import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpenseBrief.dart';
import 'package:flutter/material.dart';

import '../../components/OverviewCard.dart';

class ExpenseListHeaderCards extends StatelessWidget {
  List<ExpenseBrief> expenseBriefs;

  ExpenseListHeaderCards(this.expenseBriefs, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: expenseBriefs.map((e) => OverviewCard(e.text)).toList(),
      ),
    );
  }
}
