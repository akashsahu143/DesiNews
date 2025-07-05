import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:desishot_app/models/news_article.dart';

class NewsService {
  final String _apiKey = 'a9026f087b0b4f46a0b399d8960e0ea9'; // Replace with your actual API key
  final String _baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> fetchNews(String category) async {
    final response = await http.get(Uri.parse('$_baseUrl/top-headlines?country=in&category=$category&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body)['articles'];
      List<NewsArticle> articles = body.map((dynamic item) => NewsArticle.fromJson(item)).toList();
      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }
}


