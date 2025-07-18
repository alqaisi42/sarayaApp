class NewsModel {
  final int? id;
  final String? title;
  final String? slug;
  final String? image;
  final String? pubDate;

  NewsModel({
    this.id,
    this.title,
    this.slug,
    this.image,
    this.pubDate,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      image: json['image'] as String?,
      pubDate: json['publish_date'] ?? json['pubdate'] ?? '',
    );
  }
}
