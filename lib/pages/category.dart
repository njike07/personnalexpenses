import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:personnalexpenses/Views/setting.dart';
import 'package:personnalexpenses/main.dart';
import 'package:personnalexpenses/expense_list.dart';


class Category {
  final String name;
  final String imagePath;
  final double totalExpenses;

  Category(
      {required this.name,
      required this.imagePath,
      required this.totalExpenses});
}

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Category> categories = [
      Category(
          name: 'Food', imagePath: 'images/food.jpeg', totalExpenses: 150.0),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: GridView.builder(
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
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.purple,
        backgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 400),
        items: const <Widget>[
          Icon(Icons.bar_chart, size: 30, color: Colors.white),
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ExpenseList()),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Settings()),
            );
          }
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(category.imagePath, width: 60, height: 60),
            const SizedBox(height: 8),
            Text(category.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('\$${category.totalExpenses.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
