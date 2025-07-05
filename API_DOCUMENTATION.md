
# DesiShot API Documentation

This document provides comprehensive information about the APIs and services used in the DesiShot application.

## Overview

DesiShot integrates with multiple external APIs and Firebase services to provide a rich user experience. This documentation covers all API integrations, authentication methods, and data structures.

## External APIs

### 1. NewsAPI Integration

**Base URL**: `https://newsapi.org/v2/`

**Authentication**: API Key required

#### Endpoints Used

##### Get Top Headlines
```
GET /top-headlines
```

**Parameters:**
- `country`: `in` (India)
- `category`: `entertainment`, `politics`, `sports`, `general`
- `language`: `en`, `hi` (English, Hindi)
- `apiKey`: Your NewsAPI key

**Example Request:**
```dart
final response = await http.get(
  Uri.parse('https://newsapi.org/v2/top-headlines?country=in&category=entertainment&apiKey=YOUR_API_KEY')
);
```

**Response Structure:**
```json
{
  "status": "ok",
  "totalResults": 38,
  "articles": [
    {
      "source": {
        "id": "the-times-of-india",
        "name": "The Times of India"
      },
      "author": "Author Name",
      "title": "Article Title",
      "description": "Article description...",
      "url": "https://example.com/article",
      "urlToImage": "https://example.com/image.jpg",
      "publishedAt": "2024-01-15T10:30:00Z",
      "content": "Article content..."
    }
  ]
}
```

#### Rate Limits
- **Free Plan**: 1,000 requests per month
- **Developer Plan**: 500 requests per day
- **Business Plan**: 50,000 requests per month

#### Error Handling
```dart
if (response.statusCode == 200) {
  // Success
} else if (response.statusCode == 401) {
  // Invalid API key
} else if (response.statusCode == 429) {
  // Rate limit exceeded
} else {
  // Other errors
}
```

## Firebase Services

### 1. Firebase Authentication

#### Supported Providers
- Google Sign-In
- Phone Number (OTP)

#### Google Sign-In Implementation
```dart
Future<UserCredential?> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) return null;
  
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
```

#### Phone Authentication Implementation
```dart
Future<void> verifyPhoneNumber(String phoneNumber) async {
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      // Handle error
    },
    codeSent: (String verificationId, int? resendToken) {
      // Save verificationId for later use
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Handle timeout
    },
  );
}
```

### 2. Cloud Firestore

#### Database Structure

##### Users Collection
```
/users/{userId}
{
  "uid": "string",
  "email": "string",
  "displayName": "string",
  "photoURL": "string",
  "phoneNumber": "string",
  "preferredLanguage": "string",
  "createdAt": "timestamp",
  "lastLoginAt": "timestamp"
}
```

##### Content Collection
```
/content/{contentId}
{
  "id": "string",
  "userId": "string",
  "title": "string",
  "description": "string",
  "type": "video" | "image",
  "url": "string",
  "thumbnailUrl": "string",
  "status": "pending" | "approved" | "rejected",
  "likes": "number",
  "comments": "number",
  "shares": "number",
  "createdAt": "timestamp",
  "approvedAt": "timestamp",
  "approvedBy": "string"
}
```

##### News Metadata Collection
```
/news_metadata/{articleUrl}
{
  "url": "string",
  "likes": "number",
  "comments": "number",
  "shares": "number",
  "lastUpdated": "timestamp"
}
```

##### Sponsored Content Collection
```
/sponsored_content/{contentId}
{
  "id": "string",
  "title": "string",
  "description": "string",
  "imageUrl": "string",
  "targetUrl": "string",
  "sponsorName": "string",
  "timestamp": "timestamp"
}
```

#### Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Content is readable by all, writable by authenticated users
    match /content/{contentId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
        (request.auth.uid == resource.data.userId || 
         request.auth.token.admin == true);
    }
    
    // News metadata is readable and writable by all
    match /news_metadata/{articleId} {
      allow read, write: if true;
    }
    
    // Sponsored content is readable by all, writable by admins
    match /sponsored_content/{contentId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
  }
}
```

#### Common Queries

##### Get User Content
```dart
Stream<List<Content>> getUserContent(String userId) {
  return FirebaseFirestore.instance
    .collection('content')
    .where('userId', isEqualTo: userId)
    .where('status', isEqualTo: 'approved')
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => Content.fromFirestore(doc))
        .toList());
}
```

##### Get Pending Content for Admin
```dart
Stream<List<Content>> getPendingContent() {
  return FirebaseFirestore.instance
    .collection('content')
    .where('status', isEqualTo: 'pending')
    .orderBy('createdAt', descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => Content.fromFirestore(doc))
        .toList());
}
```

### 3. Firebase Storage

#### File Upload Structure
```
/content/
  /{userId}/
    /videos/
      /{contentId}.mp4
    /images/
      /{contentId}.jpg
    /thumbnails/
      /{contentId}_thumb.jpg
```

#### Upload Implementation
```dart
Future<String> uploadFile(File file, String path) async {
  final ref = FirebaseStorage.instance.ref().child(path);
  final uploadTask = ref.putFile(file);
  final snapshot = await uploadTask;
  return await snapshot.ref.getDownloadURL();
}
```

#### Security Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /content/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 4. Firebase Cloud Messaging

#### Topic Subscription
```dart
Future<void> subscribeToTopic(String topic) async {
  await FirebaseMessaging.instance.subscribeToTopic(topic);
}
```

#### Message Handling
```dart
void setupMessageHandling() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle foreground messages
  });
  
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle messages when app is opened from notification
  });
}
```

#### Notification Payload Structure
```json
{
  "notification": {
    "title": "DesiShot News",
    "body": "New entertainment news available!"
  },
  "data": {
    "type": "news",
    "category": "entertainment",
    "url": "https://example.com/article"
  }
}
```

## Google AdMob Integration

### Ad Unit Configuration

#### Banner Ads
```dart
BannerAd(
  adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ID
  size: AdSize.banner,
  request: AdRequest(),
  listener: BannerAdListener(
    onAdLoaded: (Ad ad) => print('Banner ad loaded'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) => print('Banner ad failed: $error'),
  ),
)
```

#### Interstitial Ads
```dart
InterstitialAd.load(
  adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ID
  request: AdRequest(),
  adLoadCallback: InterstitialAdLoadCallback(
    onAdLoaded: (InterstitialAd ad) {
      // Ad loaded successfully
    },
    onAdFailedToLoad: (LoadAdError error) {
      // Ad failed to load
    },
  ),
);
```

### Production Ad Unit IDs

Replace test IDs with production IDs before release:

#### Android
- Banner: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`
- Interstitial: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`

#### iOS
- Banner: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`
- Interstitial: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`

## Error Handling

### Network Errors
```dart
try {
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw HttpException('Failed to load data: ${response.statusCode}');
  }
} on SocketException {
  throw NetworkException('No internet connection');
} on TimeoutException {
  throw NetworkException('Request timeout');
} catch (e) {
  throw UnknownException('Unknown error: $e');
}
```

### Firebase Errors
```dart
try {
  await FirebaseFirestore.instance.collection('users').add(data);
} on FirebaseException catch (e) {
  switch (e.code) {
    case 'permission-denied':
      throw PermissionException('Access denied');
    case 'unavailable':
      throw ServiceException('Service temporarily unavailable');
    default:
      throw UnknownException('Firebase error: ${e.message}');
  }
}
```

## Rate Limiting and Caching

### NewsAPI Rate Limiting
```dart
class NewsService {
  static const int maxRequestsPerHour = 100;
  static DateTime? lastRequestTime;
  static int requestCount = 0;
  
  Future<bool> canMakeRequest() async {
    final now = DateTime.now();
    if (lastRequestTime == null || 
        now.difference(lastRequestTime!).inHours >= 1) {
      requestCount = 0;
      lastRequestTime = now;
    }
    
    return requestCount < maxRequestsPerHour;
  }
}
```

### Content Caching
```dart
class CacheService {
  static const Duration cacheExpiry = Duration(hours: 1);
  static Map<String, CachedData> cache = {};
  
  static T? getCachedData<T>(String key) {
    final cached = cache[key];
    if (cached != null && !cached.isExpired) {
      return cached.data as T;
    }
    return null;
  }
  
  static void setCachedData<T>(String key, T data) {
    cache[key] = CachedData(data, DateTime.now().add(cacheExpiry));
  }
}
```

## Performance Optimization

### Image Loading
```dart
CachedNetworkImage(
  imageUrl: article.urlToImage,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  memCacheWidth: 400, // Resize for memory efficiency
  memCacheHeight: 300,
)
```

### Pagination
```dart
Future<List<Content>> getContentPaginated({
  DocumentSnapshot? lastDocument,
  int limit = 10,
}) async {
  Query query = FirebaseFirestore.instance
    .collection('content')
    .where('status', isEqualTo: 'approved')
    .orderBy('createdAt', descending: true)
    .limit(limit);
    
  if (lastDocument != null) {
    query = query.startAfterDocument(lastDocument);
  }
  
  final snapshot = await query.get();
  return snapshot.docs.map((doc) => Content.fromFirestore(doc)).toList();
}
```

## Testing

### Unit Tests for API Services
```dart
void main() {
  group('NewsService Tests', () {
    test('should fetch news articles', () async {
      final newsService = NewsService();
      final articles = await newsService.fetchNews('entertainment');
      expect(articles, isNotEmpty);
      expect(articles.first.title, isNotNull);
    });
  });
}
```

### Integration Tests
```dart
void main() {
  group('Firebase Integration Tests', () {
    testWidgets('should authenticate user', (WidgetTester tester) async {
      // Test Firebase authentication flow
    });
  });
}
```

## Monitoring and Analytics

### Custom Events
```dart
void trackUserAction(String action, Map<String, dynamic> parameters) {
  FirebaseAnalytics.instance.logEvent(
    name: action,
    parameters: parameters,
  );
}
```

### Performance Monitoring
```dart
void trackScreenView(String screenName) {
  FirebaseAnalytics.instance.logScreenView(
    screenName: screenName,
    screenClass: screenName,
  );
}
```

---

This API documentation provides comprehensive information for developers working with the DesiShot application. For additional support or questions, please refer to the main README.md file or contact the development team.

