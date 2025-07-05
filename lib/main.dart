import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:desishot_app/firebase_options.dart';
import 'package:desishot_app/screens/news_feed_screen.dart';
import 'package:desishot_app/screens/content_feed_screen.dart';
import 'package:desishot_app/screens/upload_content_screen.dart';
import 'package:desishot_app/screens/admin_approval_screen.dart';
import 'package:desishot_app/screens/language_selection_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:desishot_app/services/notification_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:desishot_app/services/in_app_purchase_service.dart';
import 'package:desishot_app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initialize();
  MobileAds.instance.initialize(); // Initialize Google Mobile Ads SDK
  await InAppPurchaseService().initialize(); // Initialize In-App Purchase Service
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  Locale? _locale;
  bool _showLanguageSelection = false;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _checkLanguagePreference();
    _checkThemePreference();
  }

  _checkLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('languageCode');
    if (langCode == null) {
      setState(() {
        _showLanguageSelection = true;
      });
    } else {
      setState(() {
        _locale = Locale(langCode);
      });
    }
  }

  _checkThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDark = prefs.getBool('isDarkMode');
    if (isDark != null) {
      setState(() {
        _isDarkMode = isDark;
      });
    }
  }

  void setLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    setState(() {
      _locale = locale;
      _showLanguageSelection = false;
    });
    // Subscribe to a topic based on selected language
    NotificationService().subscribeToTopic(locale.languageCode);
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  static List<Widget> _widgetOptions = <Widget>[
    NewsFeedScreen(),
    ContentFeedScreen(),
    UploadContentScreen(),
    AdminApprovalScreen(), // Added AdminApprovalScreen
    Text('Profile Screen (Coming Soon)'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DesiShot',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: _locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // Add custom app localization delegate here later
      ],
      supportedLocales: [
        const Locale('en', ''), // English
        const Locale('hi', ''), // Hindi
        const Locale('ta', ''), // Tamil
        const Locale('te', ''), // Telugu
        const Locale('mr', ''), // Marathi
      ],
      home: _showLanguageSelection
          ? LanguageSelectionScreen(onLanguageSelected: setLocale)
          : Scaffold(
              body: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.article),
                    label: 'News',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.video_library),
                    label: 'Videos',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.cloud_upload),
                    label: 'Upload',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.admin_panel_settings),
                    label: 'Admin',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: toggleTheme,
                child: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                backgroundColor: AppTheme.saffron,
              ),
            ),
    );
  }
}

