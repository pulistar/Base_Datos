class Book {
  int? id;
  String title;
  String description;
  String author;
  int publicationYear;
  String genre;
  bool isDone;

  Book({
    this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.publicationYear,
    required this.genre,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'publicationYear': publicationYear,
      'genre': genre,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      author: map['author'],
      publicationYear: map['publicationYear'],
      genre: map['genre'],
      isDone: map['isDone'] == 1,
    );
  }
}
