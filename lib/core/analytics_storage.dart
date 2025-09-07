import '../models/book_model.dart';

class AnalyticsStorage {
  static final Map<String, List<Book>> _searchHistory = {};

  static void storeBooks(String query, List<Book> books) {
    _searchHistory[query] = books;
  }

  static List<Book>? getBooks(String query) {
    return _searchHistory[query];
  }
}
