

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../core/analytics_storage.dart';
import '../models/book_model.dart';

class BookState {
  final List<Book> allBooks;
  final List<Book> popularBooks;
  final List<Book> newBooks;
  final bool isLoading;
  final String error;
  final List<String> searchHistory;

  BookState({
    required this.allBooks,
    required this.popularBooks,
    required this.newBooks,
    required this.isLoading,
    required this.error,
    required this.searchHistory,
  });

  BookState copyWith({
    List<Book>? allBooks,
    List<Book>? popularBooks,
    List<Book>? newBooks,
    bool? isLoading,
    String? error,
    List<String>? searchHistory,
  }) {
    return BookState(
      allBooks: allBooks ?? this.allBooks,
      popularBooks: popularBooks ?? this.popularBooks,
      newBooks: newBooks ?? this.newBooks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }
}

class BookViewModel extends StateNotifier<BookState> {
  BookViewModel()
      : super(BookState(
    allBooks: [],
    popularBooks: [],
    newBooks: [],
    isLoading: false,
    error: '',
    searchHistory: [],
  )) {
    // Initial fetch on app start
    fetchBooks("bestseller"); // default query, ya koi preselected
  }

  Future<void> fetchBooks(String query) async {
    state = state.copyWith(isLoading: true, error: '');

    // Save to history
    if (!state.searchHistory.contains(query)) {
      state = state.copyWith(searchHistory: [...state.searchHistory, query]);
    }

    try {
      final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List?;

        if (items != null) {
          final books = items.map((item) => Book.fromJson(item)).toList();

          // Filter lists
          final popular = books.where((b) => (b.averageRating.toDouble() ?? 0) >= 4.0).toList();

          final news = books.where((b) {
            try {
              return DateTime.parse(b.publishedDate).isAfter(DateTime(2012));
            } catch (_) {
              return false;
            }
          }).toList();

          // Analytics storage
          AnalyticsStorage.storeBooks(query, books);

          state = state.copyWith(
            allBooks: books,
            popularBooks: popular,
            newBooks: news,
            isLoading: false,
            error: '',
          );
        } else {
          state = state.copyWith(error: 'No books found', isLoading: false);
        }
      } else {
        state = state.copyWith(error: 'Error: ${response.statusCode}', isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: 'Something went wrong', isLoading: false);
    }
  }
}

final bookProvider = StateNotifierProvider<BookViewModel, BookState>(
      (ref) => BookViewModel(),
);
