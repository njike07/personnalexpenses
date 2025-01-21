import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'expense_item.dart';

class AddTransaction extends StatefulWidget {
  final Function addExpense;

  AddTransaction(this.addExpense);

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void _submitData() {
    final title = titleController.text;
    final amount = double.tryParse(amountController.text);

    if (title.isEmpty || amount == null || amount <= 0) {
      return;
    }

    widget.addExpense(title, amount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
            ),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
