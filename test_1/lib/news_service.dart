import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = '38bbacba-4d08-460a-b5e4-04f73719f8ac';
  final String url = 'https://content.guardianapis.com/search?api-key=';

  Future<List<dynamic>> fetchNews() async {
    final response = await http.get(Uri.parse('$url$apiKey'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response']['results'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}
