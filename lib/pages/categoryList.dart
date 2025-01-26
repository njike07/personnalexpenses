class Category {
  final String name;
  final String iconPath; // Chemin de l'icône
  final double totalExpenses;

  Category({
    required this.name,
    required this.iconPath,
    required this.totalExpenses,
  });
}
/*
final List<Category> categories = [
  Category(name: 'Food', iconPath: 'images/food.jpeg', totalExpenses: 150.0),
  Category(
      name: 'Transport', iconPath: 'images/trans.jpeg', totalExpenses: 75.0),
  Category(
      name: 'Entertainment',
      iconPath: 'images/enter.jpeg',
      totalExpenses: 50.0),
  Category(name: 'Bills', iconPath: 'images/bill.jpeg', totalExpenses: 50.0),
];*/
