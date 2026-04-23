import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/add_book_screen.dart';
import '../screens/books_screen.dart';

class AppRoutes {
  static final BookProvider provider = BookProvider();

  static Map<String, WidgetBuilder> routes = {
    "/": (context) => const LoginScreen(),
    "/register": (context) => const RegisterScreen(),
    "/dashboard": (context) => const DashboardScreen(),

    "/add-book": (context) => ChangeNotifierProvider.value(
          value: provider,
          child: const AddBookScreen(),
        ),

    "/books": (context) => ChangeNotifierProvider.value(
          value: provider,
          child: const BooksScreen(),
        ),
  };
}