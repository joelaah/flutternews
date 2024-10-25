import 'package:demo_news/models/article.dart';
import 'package:demo_news/services/api_services.dart';
import 'package:demo_news/widgets/news_cart.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  late Future<List<Article>> _newsArticles;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _newsArticles =
        CurrentsApiService().fetchTopHeadlines(); // Use CurrentsApiService
    Future.delayed(const Duration(seconds: 3), _autoSwipe);
  }

  void _autoSwipe() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      _currentPage++;
      Future.delayed(
          const Duration(seconds: 5), _autoSwipe); // Schedule next swipe
    } else {
      _currentPage = 0; // Reset the page index
      _pageController.jumpToPage(0); // Jump to the first page
      Future.delayed(
          const Duration(seconds: 5), _autoSwipe); // Schedule next swipe
    }
  }

  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News app '),
      ),
      body: FutureBuilder<List<Article>>(
        future: _newsArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error fetching news: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news available'));
          } else {
            _totalPages =
                snapshot.data!.length; // Store the total number of pages
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _totalPages, // Use _totalPages
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final article = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(article: article),
                            ),
                          );
                        },
                        child: NewsCard(article: article),
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

// A detailed view of the article
class DetailScreen extends StatelessWidget {
  final Article article;

  const DetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty) Image.network(article.imageUrl),
            const SizedBox(height: 10),
            Text(
              article.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              article.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                final Uri url = Uri.parse(article.url);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child:
                  const Text('Read more', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
