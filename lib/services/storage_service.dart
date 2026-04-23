import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_model.dart';

class StorageService {
  static const key = "books";

  static Future<List<Book>> loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);

    if (data == null) return [];

    List jsonData = jsonDecode(data);
    return jsonData.map((e) => Book.fromJson(e)).toList();
  }

  static Future saveBooks(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    List data = books.map((e) => e.toJson()).toList();
    prefs.setString(key, jsonEncode(data));
  }
}