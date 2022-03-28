import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpenseBrief.dart';
import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpensePartition.dart';

class ExpenseOverview {
  List<ExpenseBrief> briefs;
  List<ExpensePartition> partitions;

  ExpenseOverview.fromJson(Map<String, dynamic> json)
      : briefs = (json['briefs'] as List).map((e) => ExpenseBrief.fromJson(e)).toList(growable: false),
        partitions = (json['partitions'] as List).map((e) => ExpensePartition.fromJson(e)).toList(growable: false);

  Map<String, dynamic> toJson() => {
    'briefs': briefs.map((e) => e.toJson()).toList(),
    'partitions': partitions.map((e) => e.toJson()).toList()
  };
}
