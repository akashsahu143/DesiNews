class NewsArticle {
  final String? title;
  final String? description;
  final String? urlToImage;
  final String? url;
  final String? publishedAt;
  final String? content;
  final String? author;
  final String? sourceName;
  int? likes;
  int? comments;
  int? shares;

  NewsArticle({
    this.title,
    this.description,
    this.urlToImage,
    this.url,
    this.publishedAt,
    this.content,
    this.author,
    this.sourceName,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json["title"] as String?,
      description: json["description"] as String?,
      urlToImage: json["urlToImage"] as String?,
      url: json["url"] as String?,
      publishedAt: json["publishedAt"] as String?,
      content: json["content"] as String?,
      author: json["author"] as String?,
      sourceName: json["source"]["name"] as String?,
      likes: json["likes"] as int? ?? 0,
      comments: json["comments"] as int? ?? 0,
      shares: json["shares"] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "urlToImage": urlToImage,
      "url": url,
      "publishedAt": publishedAt,
      "content": content,
      "author": author,
      "sourceName": sourceName,
      "likes": likes,
      "comments": comments,
      "shares": shares,
    };
  }
}


