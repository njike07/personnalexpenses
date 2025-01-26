class ExpenseItem {
  String title; // Retirer 'final'
  double amount; // Retirer 'final'
  DateTime date; // Retirer 'final'
  String category;

  ExpenseItem({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}
