import 'package:flutter/material.dart';

class AppTheme {
  // Indian-inspired color palette
  static const Color saffron = Color(0xFFFF9933);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF138808);
  static const Color navy = Color(0xFF000080);
  static const Color orange = Color(0xFFFF6600);
  static const Color darkBlue = Color(0xFF1A237E);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color darkGray = Color(0xFF424242);

  static ThemeData lightTheme = ThemeData(
    primarySwatch: MaterialColor(0xFFFF9933, {
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCC80),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA726),
      500: Color(0xFFFF9933),
      600: Color(0xFFFF8F00),
      700: Color(0xFFFF8F00),
      800: Color(0xFFFF8F00),
      900: Color(0xFFE65100),
    }),
    primaryColor: saffron,
    scaffoldBackgroundColor: white,
    appBarTheme: AppBarTheme(
      backgroundColor: saffron,
      foregroundColor: white,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: white,
      selectedItemColor: saffron,
      unselectedItemColor: darkGray,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: saffron,
        foregroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: darkBlue,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: darkBlue,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: darkGray,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: darkGray,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: saffron, width: 2),
      ),
      labelStyle: TextStyle(color: darkGray),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: white,
      unselectedLabelColor: white.withOpacity(0.7),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: white, width: 3),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: MaterialColor(0xFFFF9933, {
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCC80),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA726),
      500: Color(0xFFFF9933),
      600: Color(0xFFFF8F00),
      700: Color(0xFFFF8F00),
      800: Color(0xFFFF8F00),
      900: Color(0xFFE65100),
    }),
    primaryColor: saffron,
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: white,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1F1F1F),
      selectedItemColor: saffron,
      unselectedItemColor: Colors.grey[400],
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF1F1F1F),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: saffron,
        foregroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: Colors.grey[300],
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: Colors.grey[400],
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[600]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: saffron, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.grey[400]),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: white,
      unselectedLabelColor: Colors.grey[400],
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: saffron, width: 3),
      ),
    ),
  );
}

