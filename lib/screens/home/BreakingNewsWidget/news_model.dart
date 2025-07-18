class NewsModel {
  final int? id;
  final String? title;
  final String? slug;
  final String? image;
  final String? pubDate;
  final String? channelName;
  final String? channelLogo;
  final String? channelSlug;
  final int? viewCount;
  final String? type;
  final String? videoThumb;
  final String? video;

  NewsModel({
    this.id,
    this.title,
    this.slug,
    this.image,
    this.pubDate,
    this.channelName,
    this.channelLogo,
    this.channelSlug,
    this.viewCount,
    this.type,
    this.videoThumb,
    this.video,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      image: json['image'] as String?,
      pubDate: json['publish_date'] ?? json['pubdate'] ?? '',
      channelName: json['channel_name'] as String?,
      channelLogo: json['channel_logo'] as String?,
      channelSlug: json['channel_slug'] as String?,
      viewCount: json['view_count'] as int?,
      type: json['type'] as String?,
      videoThumb: json['video_thumb'] as String?,
      video: json['video'] as String?,
    );
  }
}
