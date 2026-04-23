import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book_model.dart';
import '../widgets/glass_card.dart';

class AddBookScreen extends StatefulWidget {
  final Book? book;
  final int? index;

  const AddBookScreen({super.key, this.book, this.index});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final author = TextEditingController();
  final isbn = TextEditingController();
  final qty = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    if (widget.book != null) {
      isEdit = true;

      title.text = widget.book!.title;
      author.text = widget.book!.author;
      isbn.text = widget.book!.isbn;
      qty.text = widget.book!.quantity.toString();
    }
  }

  void saveBook() {
    if (_formKey.currentState!.validate()) {
      final newBook = Book(
        id: widget.book?.id,
        title: title.text.trim(),
        author: author.text.trim(),
        isbn: isbn.text.trim(),
        quantity: int.parse(qty.text.trim()),
        issued: widget.book?.issued ?? false, // ✅ IMPORTANT
      );

      if (isEdit) {
        context.read<BookProvider>().updateBook(widget.book!.id!, newBook);
      } else {
        context.read<BookProvider>().addBook(newBook);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit
              ? "Book Updated Successfully"
              : "Book Added Successfully"),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Book" : "Add Book"),
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
        child: Center(
          child: SizedBox(
            width: 350,
            child: GlassCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEdit ? "Edit Book" : "Add Book",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: title,
                      decoration: const InputDecoration(
                        labelText: "Book Title",
                        prefixIcon: Icon(Icons.book),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Enter book title" : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: author,
                      decoration: const InputDecoration(
                        labelText: "Author Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Enter author name" : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: isbn,
                      decoration: const InputDecoration(
                        labelText: "ISBN",
                        prefixIcon: Icon(Icons.qr_code),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Enter ISBN" : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: qty,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Quantity",
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Enter quantity";
                        }
                        if (int.tryParse(v) == null) {
                          return "Enter valid number";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: saveBook,
                        child: Text(
                            isEdit ? "Update Book" : "Add Book"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}