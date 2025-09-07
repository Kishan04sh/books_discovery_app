

import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/core/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/book_model.dart';
import '../../providers/booksControllers.dart';
import '../../routes/app_router.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final List<String> filters = ["All", "Popular", "New"];
  int selectedFilterIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookProvider);

    // Determine which list to show based on selected filter
    List<Book> filteredBooks;
    if (selectedFilterIndex == 0) {
      filteredBooks = state.allBooks;
    } else if (selectedFilterIndex == 1) {
      filteredBooks = state.popularBooks;
    } else {
      filteredBooks = state.newBooks;
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Courses",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),

                  CircleAvatar(
                    backgroundColor:AppColors.primary,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search Bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Find Course",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final query = searchController.text.trim();
                      if (query.isNotEmpty) {
                        ref.read(bookProvider.notifier).fetchBooks(query);
                        searchController.clear();
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),

              const SizedBox(height: 10),

              // Search History Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.searchHistory.map((query) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(query),
                        onPressed: () {
                          ref.read(bookProvider.notifier).fetchBooks(query);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // Categories Dummy
              // SizedBox(
              //   height: 125,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       _categoryCard("Language", Colors.blue, Icons.language),
              //       _categoryCard("Painting", Colors.orange, Icons.brush),
              //     ],
              //   ),
              // ),
              //
              // const SizedBox(height: 20),

              const Text(
                "Choose your course",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              // Filters
              Row(
                children: List.generate(
                  filters.length,
                      (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilterIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedFilterIndex == index
                            ? AppColors.primary
                            : AppColors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filters[index],
                        style: TextStyle(
                          color: selectedFilterIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Books List
              Expanded(
                child: Builder(builder: (context) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  } else if (state.error.isNotEmpty) {
                    return Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    );
                  } else if (filteredBooks.isEmpty) {
                    return Center(
                      child: Text(
                        "No books found",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        return _buildBookItem(book);
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Category Card Widget
  Widget _categoryCard(String title, Color color, IconData icon) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16))
        ],
      ),
    );
  }

  /// Book Item Widget
  Widget _buildBookItem(Book book) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: book.thumbnail.isNotEmpty
            ? Image.network(book.thumbnail, width: 50, fit: BoxFit.cover)
            : Container(
          width: 50,
          height: 50,
          color: Colors.grey[300],
          child: const Icon(Icons.book),
        ),
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(book.authors.join(", ")),
        trailing: Text(
          "₹${book.pageCount}",
          style: const TextStyle(
              color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        onTap: (){
          context.pushRoute(BookDetailRoute(book: book));
        },
      ),
    );
  }

}
