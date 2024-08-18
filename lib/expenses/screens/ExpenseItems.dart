import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import 'package:finance_controlinator_mobile/expenses/components/DefaultToast.dart';
import 'package:finance_controlinator_mobile/expenses/domain/ExpenseItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class ExpenseItemsScreen extends StatefulWidget {
  List<ExpenseItem> items;

  ExpenseItemsScreen(this.items, {super.key});

  @override
  State<ExpenseItemsScreen> createState() => _ExpenseItemsScreenState();
}

class _ExpenseItemsScreenState extends State<ExpenseItemsScreen> {
  void addedItem(ExpenseItem item) {
    setState(() {
      widget.items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Items"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ExpenseItemsForm(addedItem),
            ),
            ExpenseItemsList(widget.items),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, widget.items);
                        },
                        child: const Text("Save and back")),
                  ),
                )
              ],
            )
          ],
        ));
  }
}

class ExpenseItemsForm extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _amountCostController = TextEditingController();

  FToast toast;
  Function(ExpenseItem) addedItem;

  ExpenseItemsForm(this.addedItem, {super.key}) : toast = FToast();

  @override
  Widget build(BuildContext context) {
    toast.init(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DefaultInput("Name", TextInputType.text, _nameController),
        DefaultInput("Description", TextInputType.text, _descriptionController),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child:
                  DefaultInput("Cost", TextInputType.number, _costController),
            ),
            Expanded(
              flex: 5,
              child: DefaultInput(
                  "Amount", TextInputType.number, _amountCostController),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: SizedBox(
            width: double.maxFinite,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green[900],
                    backgroundColor: Colors.green[100]),
                onPressed: () {
                  var name = _nameController.text;
                  var description = _descriptionController.text;
                  var cost = double.tryParse(_costController.text);
                  var amount = int.tryParse(_amountCostController.text);

                  if (ExpenseItem.isValidProperties(
                      name, description, cost, amount)) {
                    addedItem(ExpenseItem(
                        const Uuid().v4(), name, description, cost!, amount!));
                    toast.showToast(
                      child: DefaultToast.Success("Item Added"),
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: const Duration(seconds: 2),
                    );
                  } else {
                    toast.showToast(
                      child: DefaultToast.Error(
                          "Ops! Are all fields correct filled?"),
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: const Duration(seconds: 2),
                    );
                  }
                },
                child: const Text("Add")),
          ),
        ),
      ],
    );
    //DefaultInput("Items", TextInputType.text, _descriptionController),
  }
}

class ExpenseItemsList extends StatelessWidget {
  List<ExpenseItem> items;

  ExpenseItemsList(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 10,
        child: Builder(
          builder: (BuildContext context) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.arrow_forward),
                    title: Text(item.name),
                    subtitle: Text(
                        "Cost: ${item.cost}     Qnt: ${item.amount}     Total: ${item.totalCost()}"),
                  ),
                );
              },
              itemCount: items.length,
            );
          },
        ));
  }
}
