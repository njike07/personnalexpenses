import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personnalexpenses/expense_list.dart';
import 'package:personnalexpenses/pages/category.dart';
import 'add_transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
      ),
      home: ExpenseList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  int _currentIndex = 0; // Index de la navigation actuelle
  final List<ExpenseItem> _expenses = [];

  // Fonction pour ajouter une dépense
  void _addExpense(String title, double amount, String category) {
    final newExpense = ExpenseItem(
      title: title,
      amount: amount,
      date: DateTime.now(),
      category: category,
    );

    setState(() {
      _expenses.add(newExpense);
    });
  }

  // Fonction pour supprimer une dépense
  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  // Fonction pour afficher le dialogue de modification
  void _showEditDialog(int index) {
    final titleController = TextEditingController(text: _expenses[index].title);
    final amountController =
        TextEditingController(text: _expenses[index].amount.toString());
    DateTime selectedDate = _expenses[index].date;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Expense'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Text("Selected Date: ${DateFormat.yMd().format(selectedDate)}"),
                TextButton(
                  onPressed: () {
                    // Code pour choisir une nouvelle date peut être ajouté ici
                  },
                  child: const Text('Change Date'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final amount = double.tryParse(amountController.text);
                if (title.isEmpty || amount == null || amount <= 0) {
                  return;
                }
                // Appeler la fonction pour modifier la dépense
                setState(() {
                  _expenses[index] = ExpenseItem(
                    title: title,
                    amount: amount,
                    date: selectedDate,
                    category: _expenses[index]
                        .category, // Conserve la catégorie existante
                  );
                });
                Navigator.of(ctx).pop(); // Ferme le dialogue
              },
              child: const Text('Save Changes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour obtenir les dépenses par jour
  List<double> _getWeeklyExpenses() {
    List<double> weeklyExpenses = List.filled(7, 0.0); // Liste pour chaque jour
    for (var expense in _expenses) {
      int weekday = expense.date.weekday; // 1 = Lundi, 7 = Dimanche
      weeklyExpenses[weekday - 1] += expense.amount;
    }
    return weeklyExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Personal Expenses",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Widget pour afficher les dépenses hebdomadaires
          _buildWeeklyExpensesChart(),
          Expanded(child: _buildExpensesList()), // Liste des dépenses
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 233, 213, 33),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) => AddTransaction(_addExpense),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.purple,
        backgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 400),
        items: const <Widget>[
          Icon(Icons.bar_chart, size: 30, color: Colors.white),
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.compare_arrows, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            if (index == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CategoryPage()),
              );
            }
            _currentIndex = index; // Met à jour l'onglet actif
          });
        },
      ),
    );
  }

  // Widget pour afficher les dépenses hebdomadaires
  Widget _buildWeeklyExpensesChart() {
    List<double> expenses = _getWeeklyExpenses();
    double maxExpense =
        expenses.reduce((a, b) => a > b ? a : b); // Montant maximum
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
                height: maxBarHeight,
                width: 20,
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
              const SizedBox(height: 5),
              Text(_getWeekdayLabel(index)),
            ],
          );
        }),
      ),
    );
  }

  // Widget pour afficher la liste des dépenses
  Widget _buildExpensesList() {
    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (ctx, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Coins arrondis
          ),
          elevation: 5, // Ombre
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      '\$${_expenses[index].amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _expenses[index].title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd().format(_expenses[index].date),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit,
                      color: Colors.blue), // Icône pour modifier
                  onPressed: () => _showEditDialog(
                      index), // Appelle le dialogue de modification
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteExpense(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fonction pour obtenir le label du jour
  String _getWeekdayLabel(int index) {
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return weekdays[index];
  }
}
