import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/book_model.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class BookDetailScreen extends StatelessWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});


  /// ********************************************

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  /// ********************************************************
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "N/A",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }


  /// ************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
        title: const Text("Book Details",style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.w600,fontSize: 20),),
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: book.thumbnail.isNotEmpty
                    ? Image.network(book.thumbnail, height: 220, fit: BoxFit.cover)
                    : Container(
                  height: 220,
                  width: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.book, size: 50),
                ),
              ),
            ),


            const SizedBox(height: 20),

            // Title Card
            SizedBox(
              width: double.infinity,
              child: Card(
                color: AppColors.offWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    book.title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),


            const SizedBox(height: 10),

            // Book Info
            Card(
              color: AppColors.offWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("ID", book.id),
                    _buildInfoRow("Author(s)", book.authors.join(", ")),
                    _buildInfoRow("Publisher", book.publisher),
                    _buildInfoRow("Published", book.publishedDate),
                    _buildInfoRow("Pages", book.pageCount.toString()),
                    _buildInfoRow("Categories", book.categories.join(", ")),
                    _buildInfoRow("Language", book.language),
                    _buildInfoRow("Rating", "${book.averageRating} (${book.ratingsCount} ratings)"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Description
            Card(
              color: AppColors.offWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.description.isNotEmpty ? book.description : "No description available",
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Links
            Card(
              color: AppColors.offWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Links",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _linkButton("Preview Link", book.previewLink),
                    _linkButton("Info Link", book.infoLink),
                    _linkButton("Canonical Link", book.canonicalVolumeLink),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ********************************************************

  Widget _linkButton(String title, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(40),
        ),
        onPressed: () => _launchURL(url),
        child: Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  /// *******************************************************************************


}
