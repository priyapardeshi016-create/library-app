import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> addBook(Book book) async {
    await _db.collection("books").add(book.toJson());
  }

  static Stream<List<Book>> getBooks() {
    return _db.collection("books").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Add the document ID to the book data
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id; // Add the Firestore document ID
        return Book.fromJson(data);
      }).toList();
    });
  }

  static Future<void> deleteBook(String id) async {
    await _db.collection("books").doc(id).delete();
  }

  static Future<void> updateBook(String id, Book book) async {
    await _db.collection("books").doc(id).update(book.toJson());
  }
}