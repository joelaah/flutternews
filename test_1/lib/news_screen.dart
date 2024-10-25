import 'package:flutter/material.dart';
import 'package:test_1/fav_screen.dart';
import 'news_service.dart'; // Create this file for the API service
import 'package:share/share.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  List<dynamic> _newsArticles = [];
  List<dynamic> _filteredNewsArticles = [];
  List<dynamic> _favoriteArticles = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNews();
    _loadFavorites();
  }

  Future<void> _fetchNews() async {
    try {
      final articles = await _newsService.fetchNews();
      setState(() {
        _newsArticles = articles;
        _filteredNewsArticles = articles;
      });
    } catch (error) {
      print(error);
    }
  }

  void _filterNews(String query) {
    final filtered = _newsArticles.where((article) {
      final title = article['title'].toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredNewsArticles = filtered;
    });
  }

  void _toggleFavorite(dynamic article) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (_favoriteArticles.contains(article)) {
        _favoriteArticles.remove(article);
      } else {
        _favoriteArticles.add(article);
      }

      // Safely map and filter out null or empty titles
      List<dynamic> favoriteTitles = _favoriteArticles
          .map((a) =>
              a['title'] ?? 'No Title') // Provide default value for null titles
          .where((title) => title.isNotEmpty) // Filter out empty titles
          .toList();

      // Ensure favoriteTitles is of type List<String>
      if (favoriteTitles is List<String>) {
        prefs.setStringList('favorites', favoriteTitles);
      } else {
        print('favoriteTitles is not a List<String>');
      }
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFavorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      _favoriteArticles = savedFavorites
          .map((title) =>
              _newsArticles.firstWhere((article) => article['title'] == title))
          .toList();
    });
  }

  void _shareArticle(String url) {
    Share.share('Check out this news article: $url');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _filterNews,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            fillColor: Colors.white,
            filled: true,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FavoritesScreen(
                          favoriteArticles: _favoriteArticles)));
            },
          ),
        ],
      ),
      body: _filteredNewsArticles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredNewsArticles.length,
              itemBuilder: (context, index) {
                final article = _filteredNewsArticles[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(article['urlToImage'] ?? ''),
                    title: Text(article['title']),
                    subtitle: Text(article['description']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () => _shareArticle(article['url']),
                        ),
                        IconButton(
                          icon: Icon(
                            _favoriteArticles.contains(article)
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          onPressed: () => _toggleFavorite(article),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
