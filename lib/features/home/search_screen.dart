
import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCategoriesProvider = StateProvider<List<String>>((ref) => []);
final priceRangeProvider = StateProvider<RangeValues>((ref) => const RangeValues(90, 200));

@RoutePage()
class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategories = ref.watch(selectedCategoriesProvider);
    final priceRange = ref.watch(priceRangeProvider);

    final categories = [
      "Fiction",
      "Sci-fi",
      "Biography",
      "Music",
      "Non-fiction",
      "Mathematics"
    ];

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.router.pop(),
                  ),
                  const Text(
                    "Search Filter",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 48), // for alignment
                ],
              ),
              const SizedBox(height: 10),

              // Categories
              const Text("Categories", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = selectedCategories.contains(category);
                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedCategoriesProvider.notifier).state =
                      isSelected
                          ? (selectedCategories..remove(category)).toList()
                          : (selectedCategories..add(category)).toList();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Price
              const Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
              RangeSlider(
                activeColor: Colors.blue,
                inactiveColor: Colors.grey.shade300,
                values: priceRange,
                min: 0,
                max: 500,
                divisions: 50,
                labels: RangeLabels(
                  "₹${priceRange.start.toInt()}",
                  "₹${priceRange.end.toInt()}",
                ),
                onChanged: (values) {
                  ref.read(priceRangeProvider.notifier).state = values;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹${priceRange.start.toInt()}"),
                    Text("₹${priceRange.end.toInt()}"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ref.read(selectedCategoriesProvider.notifier).state = [];
                        ref.read(priceRangeProvider.notifier).state = const RangeValues(90, 200);
                      },
                      child: const Text("Clear", style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        // Apply filter action
                        context.router.pop();
                      },
                      child: const Text("Apply Filter", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
