import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:personnalexpenses/expense_list.dart';
import 'package:personnalexpenses/main.dart'; // Assurez-vous d'importer ExpenseList

class Category {
  final String name;
  final String imagePath; // Changer de iconPath à imagePath
  final double totalExpenses;

  Category({
    required this.name,
    required this.imagePath, // Mise à jour ici
    required this.totalExpenses,
  });
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final int _currentIndex = 1; // Index de la navigation actuelle

  final List<Category> categories = [
    Category(name: 'Food', imagePath: 'images/food.jpeg', totalExpenses: 150.0),
    Category(
        name: 'Transport',
        imagePath: 'images/transport.jpeg',
        totalExpenses: 75.0),
    Category(
        name: 'Entertainment',
        imagePath: 'images/entertainment.jpeg',
        totalExpenses: 50.0),
    Category(
        name: 'Bills', imagePath: 'images/bills.jpeg', totalExpenses: 50.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryBox(category: categories[index]);
          },
        ),
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
            if (index == 0) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ExpenseList()),
              );
            }
          });
        },
      ),
    );
  }
}

class CategoryBox extends StatelessWidget {
  final Category category;

  const CategoryBox({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.purple[50],
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                category.imagePath, // Utilisez imagePath ici
                width: 60, // Ajustez la taille si nécessaire
                height: 60,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${category.totalExpenses.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
