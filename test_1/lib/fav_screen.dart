import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<dynamic> favoriteArticles;

  FavoritesScreen({required this.favoriteArticles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Articles'),
      ),
      body: favoriteArticles.isEmpty
          ? Center(child: Text('No favorites yet.'))
          : ListView.builder(
              itemCount: favoriteArticles.length,
              itemBuilder: (context, index) {
                final article = favoriteArticles[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(article['urlToImage'] ?? ''),
                    title: Text(article['title']),
                    subtitle: Text(article['description']),
                  ),
                );
              },
            ),
    );
  }
}
