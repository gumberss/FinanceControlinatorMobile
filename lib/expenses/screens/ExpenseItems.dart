import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseItemsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Items"),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: ExpenseItemsForm(),
            ),
            ExpenseItemsList(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                  EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
                  child: SizedBox(
                    width: double.maxFinite,
                    child:
                    ElevatedButton(onPressed: () {}, child: Text("Save and back")),
                  ),
                )
              ],
            )
          ],
        ));
  }
}

class ExpenseItemsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _costController = TextEditingController();
    TextEditingController _amountCostController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DefaultInput("Name", TextInputType.text, _nameController),
            DefaultInput(
                "Description", TextInputType.text, _descriptionController),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: DefaultInput(
                      "Cost", TextInputType.number, _costController),
                ),
                Expanded(
                  flex: 5,
                  child: DefaultInput(
                      "Amount", TextInputType.number, _amountCostController),
                ),
              ],
            ),
          ],
        ),

        //DefaultInput("Items", TextInputType.text, _descriptionController),
      ],
    );
  }
}

class ExpenseItemsList extends StatelessWidget {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 10,
        child: FutureBuilder(
            initialData: List<String>.empty(growable: true),
            future: Future(() => List<String>.filled(50, "Ola")),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  //nothing was done
                  break;
                case ConnectionState.waiting:
                  //return Progress();
                  break;
                case ConnectionState.active:
                  //stream
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final List<String> contacts = snapshot.data!;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.arrow_forward),
                            title: Text(contact),
                            subtitle: Text("Subtitle"),

                          ),
                        );
                      },
                      itemCount: contacts.length,
                    );
                  }
                  break;
              }

              return Text("Treta");
            }));
  }
}
