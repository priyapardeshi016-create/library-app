import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import 'add_book_screen.dart'; // ✅ IMPORT ADD KARNA HAI

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Library Books"),
        backgroundColor: const Color(0xff5b86e5),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff36d1dc),
              Color(0xff5b86e5),
            ],
          ),
        ),
        child: provider.books.isEmpty
            ? const Center(
                child: Text(
                  "No Books Found",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: provider.books.length,
                itemBuilder: (context, i) {
                  final b = provider.books[i];

                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),

                      // 📸 IMAGE
                      leading: b.image != null
                          ? CircleAvatar(
                              radius: 25,
                              backgroundImage: FileImage(File(b.image!)),
                            )
                          : const CircleAvatar(
                              radius: 25,
                              child: Icon(Icons.book),
                            ),

                      title: Text(
                        b.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text("${b.author} • ISBN: ${b.isbn}"),
                          const SizedBox(height: 5),
                          Text("Quantity: ${b.quantity}"),
                          const SizedBox(height: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: b.issued
                                  ? Colors.red
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              b.issued ? "Issued" : "Available",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ✅ EDIT BUTTON YAHI ADD KIYA
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✏️ EDIT
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddBookScreen(
                                    book: b,
                                    index: i,
                                  ),
                                ),
                              );
                            },
                          ),

                          // 🔄 ISSUE/RETURN
                          IconButton(
                            tooltip: b.issued
                                ? "Return Book"
                                : "Issue Book",
                            icon: const Icon(Icons.swap_horiz),
                            onPressed: () =>
                                provider.toggleIssue(b.id!, !b.issued),
                          ),

                          // 🗑 DELETE
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () =>
                                provider.deleteBook(b.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}