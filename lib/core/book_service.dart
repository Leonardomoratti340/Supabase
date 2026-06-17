import 'package:flutter_supabase/models/book_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Book>> fecthBooksForCurrentUser() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return [];
    }

    final response = await _client
        .from('books')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((book) => Book.fromMap(book)).toList();
  }

  Future<void> createBook(Book book) async {
    final response = await _client.from('books').insert(book.toMap()).select();
    print("inserimento del libro $response");
  }

  Future<void> updateBook(Book book) async {
    await _client.from('books').update(book.toMap()).eq('id', book.id);
  }

  Future<void> deleteBook(String bookId) async {
    await _client.from('books').delete().eq('id', bookId);
  }
}
