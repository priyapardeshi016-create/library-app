import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/firestore_service.dart';

class BookProvider extends ChangeNotifier {
  List<Book> books = [];
  bool loading = true;

  BookProvider() {
    loadBooks();
  }

  void loadBooks() async {
    FirestoreService.getBooks().listen((updatedBooks) {
      books = updatedBooks;
      loading = false;
      notifyListeners();
    });
  }

  void addBook(Book book) async {
    await FirestoreService.addBook(book);
    notifyListeners();
  }

  void deleteBook(String id) async {
    await FirestoreService.deleteBook(id);
    notifyListeners();
  }

  void toggleIssue(String id, bool newState) async {
    int index = books.indexWhere((b) => b.id == id);
    if (index != -1) {
      books[index].issued = newState;
      await FirestoreService.updateBook(id, books[index]);
      notifyListeners();
    }
  }

  void updateBook(String id, Book updatedBook) async {
    int index = books.indexWhere((b) => b.id == id);
    if (index != -1) {
      books[index].title = updatedBook.title;
      books[index].author = updatedBook.author;
      books[index].isbn = updatedBook.isbn;
      books[index].quantity = updatedBook.quantity;
      await FirestoreService.updateBook(id, books[index]);
      notifyListeners();
    }
  }
}