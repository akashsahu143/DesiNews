import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desishot_app/models/news_article.dart';
import 'package:desishot_app/models/content.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save or update news article metadata
  Future<void> saveNewsArticleMetadata(NewsArticle article) async {
    await _db.collection("news_articles").doc(article.url!.replaceAll(".", "_")).set(article.toJson(), SetOptions(merge: true));
  }

  // Get news article metadata
  Future<NewsArticle?> getNewsArticleMetadata(String articleUrl) async {
    final doc = await _db.collection("news_articles").doc(articleUrl.replaceAll(".", "_")).get();
    if (doc.exists) {
      return NewsArticle.fromJson(doc.data()!);
    } else {
      return null;
    }
  }

  // Update like count for a news article
  Future<void> updateArticleLikes(String articleUrl, int likes) async {
    await _db.collection("news_articles").doc(articleUrl.replaceAll(".", "_")).update({"likes": likes});
  }

  // Update comment count for a news article
  Future<void> updateArticleComments(String articleUrl, int comments) async {
    await _db.collection("news_articles").doc(articleUrl.replaceAll(".", "_")).update({"comments": comments});
  }

  // Update share count for a news article
  Future<void> updateArticleShares(String articleUrl, int shares) async {
    await _db.collection("news_articles").doc(articleUrl.replaceAll(".", "_")).update({"shares": shares});
  }

  // Save or update content (video/meme)
  Future<void> saveContent(Content content) async {
    await _db.collection("content").doc(content.id).set(content.toFirestore(), SetOptions(merge: true));
  }

  // Get content by ID
  Future<Content?> getContent(String contentId) async {
    final doc = await _db.collection("content").doc(contentId).get();
    if (doc.exists) {
      return Content.fromFirestore(doc);
    } else {
      return null;
    }
  }

  // Update like count for content
  Future<void> updateContentLikes(String contentId, int likes) async {
    await _db.collection("content").doc(contentId).update({"likes": likes});
  }

  // Update comment count for content
  Future<void> updateContentComments(String contentId, int comments) async {
    await _db.collection("content").doc(contentId).update({"comments": comments});
  }

  // Update share count for content
  Future<void> updateContentShares(String contentId, int shares) async {
    await _db.collection("content").doc(contentId).update({"shares": shares});
  }

  // Get approved content stream
  Stream<List<Content>> getApprovedContentStream() {
    return _db.collection("content").where("approved", isEqualTo: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Content.fromFirestore(doc)).toList();
    });
  }

  // Get unapproved content stream for admin approval
  Stream<List<Content>> getUnapprovedContentStream() {
    return _db.collection("content").where("approved", isEqualTo: false).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Content.fromFirestore(doc)).toList();
    });
  }

  // Approve content
  Future<void> approveContent(String contentId) async {
    await _db.collection("content").doc(contentId).update({"approved": true});
  }
}




  // Save sponsored content
  Future<void> saveSponsoredContent(SponsoredContent content) async {
    await _db.collection("sponsored_content").doc(content.id).set(content.toFirestore(), SetOptions(merge: true));
  }

  // Get sponsored content stream
  Stream<List<SponsoredContent>> getSponsoredContentStream() {
    return _db.collection("sponsored_content").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => SponsoredContent.fromFirestore(doc)).toList();
    });
  }


