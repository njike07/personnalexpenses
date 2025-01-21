import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_transaction.dart';
import 'expense_item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text(
            "Personal Expenses",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ExpenseList(),
      ),
    );
  }
}

class ExpenseList extends StatefulWidget {
  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final List<ExpenseItem> _expenses = [];

  void _addExpense(String title, double amount) {
    final newExpense = ExpenseItem(
      title: title,
      amount: amount,
      date: DateTime.now(),
    );

    setState(() {
      _expenses.add(newExpense);
    });
  }

  // Fonction pour obtenir les dépenses par jour
  List<double> _getWeeklyExpenses() {
    List<double> weeklyExpenses =
        List.filled(7, 0.0); // Une liste pour chaque jour de la semaine
    for (var expense in _expenses) {
      int weekday = expense.date.weekday; // 1 = Lundi, 7 = Dimanche
      weeklyExpenses[weekday - 1] += expense.amount;
    }
    return weeklyExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildWeeklyExpensesChart(),
        Expanded(
          child: ListView.builder(
            itemCount: _expenses.length,
            itemBuilder: (ctx, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            '\$${_expenses[index].amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _expenses[index].title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat.yMMMd().format(_expenses[index].date),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          //  supprimer l'élément
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 233, 213, 33),
          shape: CircleBorder(),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (ctx) => AddTransaction(_addExpense),
            );
          },
          child: Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildWeeklyExpensesChart() {
    List<double> expenses = _getWeeklyExpenses();
    double maxExpense =
        expenses.reduce((a, b) => a > b ? a : b); // Trouver le montant maximum
    double maxBarHeight = 100.0; // Hauteur maximale de la barre

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          double heightFactor =
              maxExpense > 0 ? (expenses[index] / maxExpense) : 0;

          return Column(
            children: [
              Container(
                height: maxBarHeight, // Hauteur maximale de la barre
                width: 20, // Largeur de la barre
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: FractionallySizedBox(
                  heightFactor: heightFactor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(_getWeekdayLabel(index)),
            ],
          );
        }),
      ),
    );
  }

  String _getWeekdayLabel(int index) {
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return weekdays[index];
  }
}
