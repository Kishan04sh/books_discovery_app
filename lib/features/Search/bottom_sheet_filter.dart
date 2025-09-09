import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../providers/booksControllers.dart';
import '../home/search_screen.dart';

class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategories = ref.watch(selectedCategoriesProvider);
    final priceRange = ref.watch(priceRangeProvider);
    final categories = ["Fiction", "Sci-fi", "Biography", "Music", "Non-fiction", "Mathematics"];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.router.pop(),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    "Search Filter",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 48), // for alignment
            ],
          ),

          const SizedBox(height: 20),

          // Categories
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: categories.map((cat) {
              final isSelected = selectedCategories.contains(cat);
              return GestureDetector(
                onTap: () {
                  ref.read(selectedCategoriesProvider.notifier).state =
                  isSelected ? (selectedCategories..remove(cat)).toList() : (selectedCategories..add(cat)).toList();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                        : [],
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 25),

          // Price Slider
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 10),
          RangeSlider(
            values: priceRange,
            min: 0,
            max: 500,
            divisions: 50,
            activeColor: AppColors.primary,
            inactiveColor: Colors.grey.shade300,
            labels: RangeLabels("₹${priceRange.start.toInt()}", "₹${priceRange.end.toInt()}"),
            onChanged: (values) => ref.read(priceRangeProvider.notifier).state = values,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("₹${priceRange.start.toInt()}"), Text("₹${priceRange.end.toInt()}")],
            ),
          ),

          const SizedBox(height: 30),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(selectedCategoriesProvider.notifier).state = [];
                    ref.read(priceRangeProvider.notifier).state = const RangeValues(90, 200);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text("Clear", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    String query = selectedCategories.isNotEmpty
                        ? selectedCategories.join(" OR ")
                        : "bestseller";
                    ref.read(bookProvider.notifier).fetchBooks(query);
                    Navigator.pop(context); // Close bottom sheet
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 5,
                  ),
                  child: const Text("Apply", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
