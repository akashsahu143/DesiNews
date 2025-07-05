
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final Function(Locale) onLanguageSelected;

  LanguageSelectionScreen({required this.onLanguageSelected});

  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'हिंदी', 'code': 'hi'},
    {'name': 'தமிழ்', 'code': 'ta'},
    {'name': 'తెలుగు', 'code': 'te'},
    {'name': 'मराठी', 'code': 'mr'},
  ];

  void _setLocale(BuildContext context, String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    onLanguageSelected(Locale(languageCode));
    Navigator.pop(context); // Go back to the previous screen after selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final lang = languages[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text(lang['name']!),
              onTap: () => _setLocale(context, lang['code']!),
            ),
          );
        },
      ),
    );
  }
}


