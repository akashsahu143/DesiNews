# DesiShot - Regional Content App for India

DesiShot is a comprehensive Flutter-based mobile application designed specifically for the Indian audience to access trending news and short videos in local languages. The app combines news consumption, video sharing, and social interaction in a single platform optimized for India's mobile-first, multilingual audience.

## Features

### Core Features
- **Multi-language Support**: Hindi, Tamil, Telugu, Marathi, and English
- **News Feed**: Categorized news (Entertainment, Politics, Sports, Lifestyle) powered by NewsAPI
- **Short Videos & Memes**: User-generated content with like, comment, and share functionality
- **Social Interactions**: Like, comment, and share on all content types
- **User Authentication**: Google Sign-In and OTP-based phone authentication via Firebase
- **Push Notifications**: Personalized notifications based on language preferences

### Advanced Features
- **Admin Approval System**: Content moderation for user-generated videos and memes
- **Monetization**: Google AdMob integration with banner and interstitial ads
- **Sponsored Content**: Integrated sponsored posts in news and video feeds
- **Dark Mode**: Complete dark theme support
- **Responsive Design**: Optimized for various screen sizes
- **Offline Support**: Cached content for better user experience

## Technology Stack

### Frontend
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language for Flutter development

### Backend & Services
- **Firebase Authentication**: User authentication and management
- **Firebase Firestore**: Real-time database for user data and content metadata
- **Firebase Storage**: File storage for user-uploaded videos and images
- **Firebase Cloud Messaging**: Push notifications
- **NewsAPI**: External API for fetching news content

### Monetization
- **Google AdMob**: Advertisement integration
- **In-App Purchases**: Subscription management (framework ready)

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── theme/
│   └── app_theme.dart       # App theming and colors
├── models/
│   ├── news_article.dart    # News article data model
│   ├── content.dart         # Video/meme content model
│   └── sponsored_content.dart # Sponsored content model
├── services/
│   ├── auth_service.dart    # Authentication service
│   ├── news_service.dart    # News API integration
│   ├── firestore_service.dart # Firestore database operations
│   ├── notification_service.dart # Push notifications
│   ├── ad_service.dart      # AdMob integration
│   └── in_app_purchase_service.dart # In-app purchases
├── screens/
│   ├── news_feed_screen.dart # News feed interface
│   ├── content_feed_screen.dart # Video/meme feed
│   ├── upload_content_screen.dart # Content upload
│   ├── admin_approval_screen.dart # Admin moderation
│   ├── video_player_screen.dart # Video playback
│   └── language_selection_screen.dart # Language selection
└── widgets/
    ├── banner_ad_widget.dart # Banner advertisement widget
    ├── loading_widget.dart   # Custom loading indicator
    └── error_widget.dart     # Error handling widget
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Firebase project setup
- NewsAPI account and API key
- Google AdMob account (for monetization)

### Firebase Configuration

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project named "DesiShot"

2. **Enable Firebase Services**
   - Authentication (Google and Phone providers)
   - Firestore Database
   - Storage
   - Cloud Messaging

3. **Download Configuration Files**
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`

### NewsAPI Setup

1. Register at [NewsAPI.org](https://newsapi.org/register)
2. Get your API key
3. Replace the API key in `lib/services/news_service.dart`

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd desishot_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Place `google-services.json` in `android/app/`
   - Place `GoogleService-Info.plist` in `ios/Runner/`

4. **Update API keys**
   - NewsAPI key in `lib/services/news_service.dart`
   - AdMob app IDs in platform-specific files

5. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

### Language Support
The app supports the following languages:
- English (en)
- Hindi (hi)
- Tamil (ta)
- Telugu (te)
- Marathi (mr)

### News Categories
- Entertainment
- Politics
- Sports
- Lifestyle

### Content Types
- News articles with social interactions
- Short videos (user-generated)
- Memes and images (user-generated)
- Sponsored content

## User Guide

### Getting Started
1. **Language Selection**: Choose your preferred language on first launch
2. **Authentication**: Sign in using Google or phone number
3. **Explore Content**: Browse news, videos, and memes
4. **Interact**: Like, comment, and share content
5. **Upload**: Create and share your own videos and memes

### Features Overview

#### News Feed
- Swipe between categories (Entertainment, Politics, Sports, Lifestyle)
- Tap articles to read full content
- Like, comment, and share articles
- View sponsored content integrated in feed

#### Video Feed
- Scroll through approved user-generated videos
- Tap to play videos in full-screen mode
- Like, comment, and share videos
- Upload your own content for admin approval

#### Content Upload
- Select videos or images from gallery
- Add title and description
- Submit for admin approval
- Track approval status

#### Admin Features
- Review pending content submissions
- Approve or reject user-generated content
- Monitor content quality and compliance

## Deployment

### Android Deployment

1. **Build APK**
   ```bash
   flutter build apk --release
   ```

2. **Build App Bundle** (for Play Store)
   ```bash
   flutter build appbundle --release
   ```

### iOS Deployment

1. **Build iOS**
   ```bash
   flutter build ios --release
   ```

2. **Archive in Xcode** for App Store submission

### Production Considerations

1. **API Keys**: Ensure all API keys are properly configured
2. **Firebase Security Rules**: Configure appropriate security rules
3. **Content Moderation**: Set up admin accounts for content approval
4. **Analytics**: Enable Firebase Analytics for user insights
5. **Crash Reporting**: Configure Firebase Crashlytics

## Troubleshooting

### Common Issues

1. **Firebase Configuration**
   - Ensure configuration files are in correct directories
   - Verify Firebase project settings match app bundle IDs

2. **API Issues**
   - Check NewsAPI key validity and quota
   - Verify internet connectivity for API calls

3. **Build Issues**
   - Run `flutter clean` and `flutter pub get`
   - Check Flutter and Dart SDK versions

4. **Authentication Issues**
   - Verify Firebase Authentication providers are enabled
   - Check SHA-1 fingerprints for Android

### Performance Optimization

1. **Image Loading**: Implement image caching for better performance
2. **Video Streaming**: Use adaptive streaming for videos
3. **Database Queries**: Optimize Firestore queries with proper indexing
4. **Memory Management**: Dispose controllers and streams properly

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the troubleshooting guide above

## Roadmap

### Upcoming Features
- Video editing capabilities
- Live streaming support
- Advanced content filtering
- Regional news sources integration
- Enhanced social features
- Improved monetization options

---

**DesiShot** - Connecting India through regional content and local languages.

