import 'package:flutter/material.dart';
import 'package:todo_sqlite/book.dart';
import 'package:todo_sqlite/database_helper.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const BookListScreen(), 
    );
  }
}

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final _dbHelper = DatabaseHelper.instance;
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final books = await _dbHelper.getBooks();
    setState(() {
      _books = books.map((map) => Book.fromMap(map)).toList();
    });
  }

  Future<void> _addBook(String title, String author, int year, String genre) async {
    final book = Book(
      title: title,
      description: 'A great book', 
      author: author,
      publicationYear: year,
      genre: genre,
    );
    await _dbHelper.insertBook(book.toMap());
    _loadBooks();
  }

  Future<void> _toggleBook(Book book) async {
    book.isDone = !book.isDone;
    await _dbHelper.updateBook(book.toMap());
    _loadBooks();
  }

  Future<void> _deleteBook(int id) async {
    await _dbHelper.deleteBook(id);
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController authorController = TextEditingController();
    final TextEditingController yearController = TextEditingController();
    final TextEditingController genreController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List (Sqlite)'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter book title',
                  ),
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(
                    hintText: 'Enter author name',
                  ),
                ),
                TextField(
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter publication year',
                  ),
                ),
                TextField(
                  controller: genreController,
                  decoration: const InputDecoration(
                    hintText: 'Enter book genre',
                  ),
                  onSubmitted: (value) {
                    if (titleController.text.isNotEmpty &&
                        authorController.text.isNotEmpty &&
                        yearController.text.isNotEmpty &&
                        genreController.text.isNotEmpty) {
                      _addBook(
                        titleController.text,
                        authorController.text,
                        int.parse(yearController.text),
                        genreController.text,
                      );
                      titleController.clear();
                      authorController.clear();
                      yearController.clear();
                      genreController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return ListTile(
                  title: Text(
                    book.title,
                    style: TextStyle(
                      decoration: book.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text('${book.author} - ${book.publicationYear}'),
                  leading: Checkbox(
                    value: book.isDone,
                    onChanged: (value) {
                      _toggleBook(book);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteBook(book.id!);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
