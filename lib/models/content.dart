import 'package:cloud_firestore/cloud_firestore.dart';

enum ContentType {
  video,
  meme,
}

class Content {
  final String id;
  final String userId;
  final String url;
  final ContentType type;
  final String title;
  final String description;
  int likes;
  int comments;
  int shares;
  bool approved;
  final Timestamp timestamp;

  Content({
    required this.id,
    required this.userId,
    required this.url,
    required this.type,
    required this.title,
    this.description = '',
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.approved = false,
    required this.timestamp,
  });

  factory Content.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Content(
      id: doc.id,
      userId: data["userId"],
      url: data["url"],
      type: ContentType.values.firstWhere((e) => e.toString() == data["type"]),
      title: data["title"],
      description: data["description"] ?? '',
      likes: data["likes"] ?? 0,
      comments: data["comments"] ?? 0,
      shares: data["shares"] ?? 0,
      approved: data["approved"] ?? false,
      timestamp: data["timestamp"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userId": userId,
      "url": url,
      "type": type.toString(),
      "title": title,
      "description": description,
      "likes": likes,
      "comments": comments,
      "shares": shares,
      "approved": approved,
      "timestamp": timestamp,
    };
  }
}


