import 'package:cloud_firestore/cloud_firestore.dart';

class SponsoredContent {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String targetUrl;
  final String sponsorName;
  final Timestamp timestamp;

  SponsoredContent({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.targetUrl,
    required this.sponsorName,
    required this.timestamp,
  });

  factory SponsoredContent.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SponsoredContent(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      targetUrl: data['targetUrl'] ?? '',
      sponsorName: data['sponsorName'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'targetUrl': targetUrl,
      'sponsorName': sponsorName,
      'timestamp': timestamp,
    };
  }
}


