
import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/features/home/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../models/book_model.dart';
import '../../providers/booksControllers.dart';
import '../../routes/app_router.dart';
import '../Search/bottom_sheet_filter.dart';

/// ------------------ FILTER STATE ------------------
final selectedCategoriesProvider = StateProvider<List<String>>((ref) => []);
final priceRangeProvider = StateProvider<RangeValues>((ref) => const RangeValues(90, 200));
final isGridViewProvider = StateProvider<bool>((ref) => false);

/// ------------------ SEARCH SCREEN ------------------
@RoutePage()
class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGridView = ref.watch(isGridViewProvider);
    final imageFile = ref.watch(imageProvider);
    final user = FirebaseAuth.instance.currentUser;
    final bookState = ref.watch(bookProvider);

    return Scaffold(
      backgroundColor: AppColors.white,

      /// *********************************************** AppBar
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Search Book",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [

          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.primary, size: 28),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                builder: (context) => const FilterBottomSheet(),
              );
            },
          ),

          const SizedBox(width: 5),

          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view,
                color: isGridView ? AppColors.primary : AppColors.googleRed, size: 28),
            onPressed: () {
              ref.read(isGridViewProvider.notifier).state = !isGridView;
            },
          ),

          const SizedBox(width: 5),

          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              backgroundImage: imageFile != null
                  ? FileImage(imageFile)
                  : (user?.photoURL != null ? NetworkImage(user!.photoURL!) as ImageProvider : null),
              child: (imageFile == null && user?.photoURL == null)
                  ? const Icon(Icons.add_a_photo, color: Colors.white)
                  : null,
            ),
          ),

          const SizedBox(width: 10),
        ],
        elevation: 2,
      ),

      /// *********************************************** Body
      body: SafeArea(
        child: Builder(builder: (context) {
          if (bookState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (bookState.error.isNotEmpty) {
            return Center(
              child: Text(
                bookState.error,
                style: const TextStyle(color: AppColors.googleRed),
              ),
            );
          } else {
            final selectedCategories = ref.watch(selectedCategoriesProvider);
            final priceRange = ref.watch(priceRangeProvider);

            final books = bookState.allBooks.where((b) {
              final price = b.pageCount ?? 0;
              final matchesCategory = selectedCategories.isEmpty
                  ? true
                  : selectedCategories.any((cat) => b.categories.contains(cat));
              final matchesPrice = price >= priceRange.start && price <= priceRange.end;
              return matchesCategory && matchesPrice;
            }).toList();

            if (books.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "No books found",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ref.watch(isGridViewProvider)
                ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return _buildBookGridItem(context, book);
              },
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return _buildBookItem(context, book);
              },
            );
          }
        }),
      ),

    );
  }

  /// ******************************************************* List Item
  Widget _buildBookItem(BuildContext context, Book book) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: book.thumbnail.isNotEmpty
            ? Image.network(book.thumbnail, width: 50, fit: BoxFit.cover)
            : Container(
          width: 50,
          height: 50,
          color: Colors.grey[300],
          child: const Icon(Icons.book),
        ),
        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(book.authors.join(", ")),
        trailing: Text("₹${book.pageCount}",
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        onTap: () {
          context.pushRoute(BookDetailRoute(book: book));
        },
      ),
    );
  }

  /// ******************************************************* Grid Item
  Widget _buildBookGridItem(BuildContext context, Book book) {
    return Card(
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.pushRoute(BookDetailRoute(book: book));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: book.thumbnail.isNotEmpty
                    ? Image.network(book.thumbnail, fit: BoxFit.cover)
                    : Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.book),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(book.title,
                  maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(book.authors.join(", "),
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Text("₹${book.pageCount}",
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, color: AppColors.primary)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// **********************************************************
}




