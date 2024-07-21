class NewsArticle {
  final String headline;
  final String updatedAt;
  final String author;
  final String url;

  NewsArticle({
    required this.headline,
    required this.updatedAt,
    required this.author,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      headline: json['headline'],
      updatedAt: json['updated_at'],
      author: json['author'],
      url: json['url'],
    );
  }
}