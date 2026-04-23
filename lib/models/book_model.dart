class Book {
  String? id; // Firestore document ID
  String title;
  String author;
  String isbn;
  String? image;
  int quantity;
  bool issued;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.quantity,
    this.issued = false,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
      "isbn": isbn,
      "image": image,
      "quantity": quantity,
      "issued": issued,
    };
  }

  factory Book.fromJson(Map json) {
    return Book(
      id: json["id"],
      title: json["title"],
      author: json["author"],
      isbn: json["isbn"],
      quantity: json["quantity"],
      issued: json["issued"],
      image: json["image"],
    );
  }
}