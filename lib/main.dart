import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personnalexpenses/pages/category.dart';
import 'package:personnalexpenses/expense_list.dart';

class UiProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  late SharedPreferences storage;

  // Thèmes personnalisés
  final darkTheme = ThemeData(
    primaryColor: Colors.black12,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black12,
  );

  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    primaryColorDark: Colors.white,
  );

  // Action pour changer le thème
  Future<void> changeTheme() async {
    _isDark = !_isDark;
    await storage.setBool("isDark", _isDark);
    notifyListeners();
  }

  // Méthode d'initialisation du provider
  Future<void> init() async {
    storage = await SharedPreferences.getInstance();
    _isDark = storage.getBool("isDark") ?? false;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final uiProvider = UiProvider();
  await uiProvider.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => uiProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, uiProvider, child) {
        return MaterialApp(
          title: 'Personal Expenses',
          theme:
              uiProvider.isDark ? uiProvider.darkTheme : uiProvider.lightTheme,
          home: const ExpenseList(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
