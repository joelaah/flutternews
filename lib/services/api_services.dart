// services/currents_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class CurrentsApiService {
  final String apiKey =
      '994u5lcTzztIugpnVP6x3kPWTvIymR7cSnsYj9Mq4-GciaXR'; // Replace with your Currents API key

  Future<List<Article>> fetchTopHeadlines() async {
    const String url = 'https://api.currentsapi.services/v1/latest-news';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List articlesJson = data['news'];

      List<Article> articles =
          articlesJson.map((json) => Article.fromJson(json)).toList();
      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
