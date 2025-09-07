class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String description;
  final int pageCount;
  final List<String> categories;
  final double averageRating;
  final int ratingsCount;
  final String thumbnail;
  final String language;
  final String previewLink;
  final String infoLink;
  final String canonicalVolumeLink;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.pageCount,
    required this.categories,
    required this.averageRating,
    required this.ratingsCount,
    required this.thumbnail,
    required this.language,
    required this.previewLink,
    required this.infoLink,
    required this.canonicalVolumeLink,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};

    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'No Title',
      authors: (volumeInfo['authors'] as List?)?.map((e) => e as String).toList() ?? [],
      publisher: volumeInfo['publisher'] ?? 'Unknown Publisher',
      publishedDate: volumeInfo['publishedDate'] ?? 'Unknown Date',
      description: volumeInfo['description'] ?? 'No Description',
      pageCount: volumeInfo['pageCount'] ?? 0,
      categories: (volumeInfo['categories'] as List?)?.map((e) => e as String).toList() ?? [],
      averageRating: (volumeInfo['averageRating'] != null)
          ? (volumeInfo['averageRating'] as num).toDouble()
          : 0.0,
      ratingsCount: volumeInfo['ratingsCount'] ?? 0,
      thumbnail: imageLinks['thumbnail'] ?? '',
      language: volumeInfo['language'] ?? 'Unknown',
      previewLink: volumeInfo['previewLink'] ?? '',
      infoLink: volumeInfo['infoLink'] ?? '',
      canonicalVolumeLink: volumeInfo['canonicalVolumeLink'] ?? '',
    );
  }
}
