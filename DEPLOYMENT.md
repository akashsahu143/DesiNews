
# DesiShot Deployment Guide

This guide provides step-by-step instructions for deploying the DesiShot app to production environments.

## Pre-deployment Checklist

### 1. Code Review and Testing
- [ ] All features tested on multiple devices
- [ ] Performance testing completed
- [ ] Memory leak testing performed
- [ ] Network connectivity edge cases handled
- [ ] Error handling implemented for all user flows

### 2. Configuration Verification
- [ ] Production Firebase project configured
- [ ] NewsAPI production key configured
- [ ] AdMob production app IDs set
- [ ] All test/debug configurations removed
- [ ] App signing certificates prepared

### 3. Content and Compliance
- [ ] Content moderation policies defined
- [ ] Admin accounts created and tested
- [ ] Privacy policy and terms of service prepared
- [ ] App store compliance requirements met

## Android Deployment

### Step 1: Prepare Release Build

1. **Update app version in pubspec.yaml**
   ```yaml
   version: 1.0.0+1
   ```

2. **Configure app signing**
   - Create keystore file:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
   
   - Create `android/key.properties`:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-upload-keystore.jks>
   ```

3. **Update android/app/build.gradle**
   ```gradle
   android {
       ...
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

### Step 2: Build Release APK/Bundle

1. **Build App Bundle (recommended for Play Store)**
   ```bash
   flutter build appbundle --release
   ```

2. **Build APK (for direct distribution)**
   ```bash
   flutter build apk --release
   ```

### Step 3: Google Play Store Submission

1. **Create Play Console Account**
   - Go to [Google Play Console](https://play.google.com/console)
   - Pay one-time registration fee ($25)

2. **Create App Listing**
   - App name: "DesiShot"
   - Category: News & Magazines
   - Content rating: Appropriate for all audiences
   - Target audience: India

3. **Upload App Bundle**
   - Navigate to Release → Production
   - Upload the generated `.aab` file
   - Complete store listing with screenshots and descriptions

4. **Configure App Details**
   - Short description (80 characters)
   - Full description (4000 characters)
   - Screenshots for different device types
   - Feature graphic (1024 x 500)
   - App icon (512 x 512)

## iOS Deployment

### Step 1: Xcode Configuration

1. **Open iOS project in Xcode**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configure signing**
   - Select Runner target
   - Go to Signing & Capabilities
   - Select your development team
   - Ensure bundle identifier matches Firebase configuration

3. **Update Info.plist**
   - Add required permissions for camera, microphone, photos
   - Configure URL schemes for Firebase

### Step 2: Build for Release

1. **Archive the app**
   - Product → Archive in Xcode
   - Wait for archive to complete

2. **Validate the archive**
   - Click "Validate App"
   - Fix any validation issues

### Step 3: App Store Submission

1. **Create App Store Connect Account**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Enroll in Apple Developer Program ($99/year)

2. **Create App Record**
   - App name: "DesiShot"
   - Bundle ID: matches your app
   - SKU: unique identifier

3. **Upload Build**
   - Use Xcode Organizer or Application Loader
   - Upload the archived build

4. **Complete App Information**
   - App description and keywords
   - Screenshots for different device sizes
   - App preview videos (optional)
   - Privacy policy URL

## Firebase Production Setup

### 1. Create Production Firebase Project

1. **New Firebase Project**
   - Name: "DesiShot Production"
   - Enable Google Analytics

2. **Configure Authentication**
   - Enable Google Sign-In
   - Enable Phone Authentication
   - Add production SHA-1 fingerprints

3. **Setup Firestore Database**
   - Create database in production mode
   - Configure security rules:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       match /content/{contentId} {
         allow read: if true;
         allow write: if request.auth != null;
       }
       match /news_metadata/{articleId} {
         allow read, write: if true;
       }
     }
   }
   ```

4. **Configure Storage**
   - Setup storage bucket
   - Configure security rules for file uploads

5. **Setup Cloud Messaging**
   - Generate server key for push notifications
   - Configure topic-based messaging

### 2. Update App Configuration

1. **Replace Firebase config files**
   - Download production `google-services.json`
   - Download production `GoogleService-Info.plist`

2. **Update API endpoints**
   - Ensure all Firebase references point to production

## AdMob Production Setup

### 1. Create AdMob Account

1. **Sign up at [AdMob](https://admob.google.com)**
2. **Create new app**
   - Platform: Android/iOS
   - App name: DesiShot

### 2. Create Ad Units

1. **Banner Ad Unit**
   - Format: Banner
   - Name: "DesiShot Banner"

2. **Interstitial Ad Unit**
   - Format: Interstitial
   - Name: "DesiShot Interstitial"

### 3. Update App Configuration

1. **Replace test ad unit IDs**
   - Update `banner_ad_widget.dart`
   - Update `ad_service.dart`

2. **Add AdMob app IDs**
   - Android: `android/app/src/main/AndroidManifest.xml`
   - iOS: `ios/Runner/Info.plist`

## Production Monitoring

### 1. Firebase Analytics

1. **Enable Analytics**
   - Automatic event tracking
   - Custom event tracking for user interactions

2. **Setup Conversion Tracking**
   - Track app installs
   - Track user engagement
   - Monitor retention rates

### 2. Crashlytics

1. **Enable Crashlytics**
   ```bash
   flutter pub add firebase_crashlytics
   ```

2. **Initialize in main.dart**
   ```dart
   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
   ```

### 3. Performance Monitoring

1. **Add Performance plugin**
   ```bash
   flutter pub add firebase_performance
   ```

2. **Monitor key metrics**
   - App startup time
   - Screen rendering performance
   - Network request performance

## Post-Deployment Tasks

### 1. User Feedback Monitoring

1. **Setup feedback channels**
   - App store reviews monitoring
   - In-app feedback system
   - Support email setup

2. **Analytics Review**
   - Daily active users
   - Session duration
   - Feature usage statistics

### 2. Content Moderation

1. **Admin Training**
   - Content approval guidelines
   - Moderation tools usage
   - Escalation procedures

2. **Automated Filtering**
   - Implement content filtering algorithms
   - Setup automated flagging system

### 3. Performance Optimization

1. **Monitor App Performance**
   - Loading times
   - Memory usage
   - Battery consumption

2. **Regular Updates**
   - Bug fixes
   - Feature enhancements
   - Security updates

## Rollback Procedures

### 1. Emergency Rollback

1. **App Store Rollback**
   - Remove current version from sale
   - Promote previous stable version

2. **Firebase Rollback**
   - Revert database rules if needed
   - Restore previous configuration

### 2. Gradual Rollout

1. **Staged Deployment**
   - Release to 5% of users initially
   - Monitor for issues
   - Gradually increase percentage

2. **A/B Testing**
   - Test new features with subset of users
   - Compare performance metrics
   - Full rollout based on results

## Security Considerations

### 1. API Security

1. **Secure API Keys**
   - Use environment variables
   - Implement API key rotation
   - Monitor API usage

2. **Network Security**
   - Use HTTPS for all communications
   - Implement certificate pinning
   - Validate server certificates

### 2. Data Protection

1. **User Data**
   - Implement data encryption
   - Follow GDPR compliance
   - Provide data deletion options

2. **Content Security**
   - Validate all user uploads
   - Scan for malicious content
   - Implement content signing

## Maintenance Schedule

### Daily Tasks
- Monitor app performance metrics
- Review user feedback and ratings
- Check for critical errors in logs

### Weekly Tasks
- Review content moderation queue
- Analyze user engagement metrics
- Update news content categories if needed

### Monthly Tasks
- Security audit and updates
- Performance optimization review
- Feature usage analysis and planning

### Quarterly Tasks
- Major feature releases
- Comprehensive security review
- User survey and feedback analysis

---

This deployment guide ensures a smooth transition from development to production while maintaining high standards of security, performance, and user experience.

