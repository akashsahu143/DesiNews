import 'package:flutter/material.dart';
import 'package:desishot_app/services/news_service.dart';
import 'package:desishot_app/models/news_article.dart';
import 'package:desishot_app/services/firestore_service.dart';
import 'package:desishot_app/widgets/banner_ad_widget.dart';
import 'package:desishot_app/services/ad_service.dart';
import 'package:desishot_app/models/sponsored_content.dart';
import 'package:desishot_app/widgets/loading_widget.dart';
import 'package:desishot_app/widgets/error_widget.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen>
    with TickerProviderStateMixin {
  final NewsService _newsService = NewsService();
  final FirestoreService _firestoreService = FirestoreService();
  final AdService _adService = AdService();
  late Future<List<NewsArticle>> _futureNews;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _futureNews = _newsService.fetchNews('general'); // Default category
    _adService.loadInterstitialAd(); // Load interstitial ad when screen initializes
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _futureNews = _newsService.fetchNews(category);
    });
    _adService.showInterstitialAd(); // Show interstitial ad on category change
    _animationController.reset();
    _animationController.forward();
  }

  void _updateLikes(NewsArticle article) async {
    if (article.url != null) {
      NewsArticle? storedArticle = await _firestoreService.getNewsArticleMetadata(article.url!);
      int currentLikes = storedArticle?.likes ?? 0;
      await _firestoreService.updateArticleLikes(article.url!, currentLikes + 1);
      setState(() {
        article.likes = currentLikes + 1;
      });
    }
  }

  void _updateComments(NewsArticle article) async {
    if (article.url != null) {
      NewsArticle? storedArticle = await _firestoreService.getNewsArticleMetadata(article.url!);
      int currentComments = storedArticle?.comments ?? 0;
      await _firestoreService.updateArticleComments(article.url!, currentComments + 1);
      setState(() {
        article.comments = currentComments + 1;
      });
    }
  }

  void _updateShares(NewsArticle article) async {
    if (article.url != null) {
      NewsArticle? storedArticle = await _firestoreService.getNewsArticleMetadata(article.url!);
      int currentShares = storedArticle?.shares ?? 0;
      await _firestoreService.updateArticleShares(article.url!, currentShares + 1);
      setState(() {
        article.shares = currentShares + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.newspaper, color: Colors.white),
              SizedBox(width: 8),
              Text("DesiShot News"),
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            onTap: (index) {
              String category;
              switch (index) {
                case 0:
                  category = "entertainment";
                  break;
                case 1:
                  category = "politics";
                  break;
                case 2:
                  category = "sports";
                  break;
                case 3:
                  category = "lifestyle";
                  break;
                default:
                  category = "general";
              }
              _onCategorySelected(category);
            },
            tabs: [
              Tab(
                icon: Icon(Icons.movie),
                text: "Entertainment",
              ),
              Tab(
                icon: Icon(Icons.account_balance),
                text: "Politics",
              ),
              Tab(
                icon: Icon(Icons.sports_soccer),
                text: "Sports",
              ),
              Tab(
                icon: Icon(Icons.style),
                text: "Lifestyle",
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _buildNewsList("entertainment"),
                  _buildNewsList("politics"),
                  _buildNewsList("sports"),
                  _buildNewsList("lifestyle"),
                ],
              ),
            ),
            BannerAdWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList(String category) {
    return FutureBuilder<List<NewsArticle>>(
      future: _newsService.fetchNews(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget(message: "Loading latest news...");
        } else if (snapshot.hasError) {
          return CustomErrorWidget(
            message: "Failed to load news. Please check your internet connection.",
            onRetry: () {
              setState(() {
                _futureNews = _newsService.fetchNews(category);
              });
            },
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return StreamBuilder<List<SponsoredContent>>(
            stream: _firestoreService.getSponsoredContentStream(),
            builder: (context, sponsoredSnapshot) {
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _animationController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeOut,
                      )),
                      child: _buildNewsListView(snapshot.data!, sponsoredSnapshot),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No news available for this category",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildNewsListView(List<NewsArticle> articles, AsyncSnapshot<List<SponsoredContent>> sponsoredSnapshot) {
    List<Widget> listItems = [];
    int sponsoredContentIndex = 0;

    for (int i = 0; i < articles.length; i++) {
      NewsArticle article = articles[i];
      listItems.add(_buildNewsCard(article, i));

      // Insert sponsored content every 5 news articles
      if ((i + 1) % 5 == 0 && sponsoredSnapshot.hasData && sponsoredSnapshot.data!.isNotEmpty) {
        if (sponsoredContentIndex < sponsoredSnapshot.data!.length) {
          SponsoredContent sponsored = sponsoredSnapshot.data![sponsoredContentIndex];
          listItems.add(_buildSponsoredCard(sponsored));
          sponsoredContentIndex++;
        }
      }
    }

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 50)),
          curve: Curves.easeOut,
          child: listItems[index],
        );
      },
    );
  }

  Widget _buildNewsCard(NewsArticle article, int index) {
    return Card(
      child: InkWell(
        onTap: () {
          // Navigate to article detail screen
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.urlToImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    article.urlToImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  ),
                ),
              SizedBox(height: 12),
              Text(
                article.title ?? "No Title",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                article.description ?? "No Description",
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.source, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      article.sourceName ?? "Unknown Source",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInteractionButton(
                    icon: Icons.thumb_up_outlined,
                    label: '${article.likes ?? 0}',
                    onTap: () => _updateLikes(article),
                  ),
                  _buildInteractionButton(
                    icon: Icons.comment_outlined,
                    label: '${article.comments ?? 0}',
                    onTap: () => _updateComments(article),
                  ),
                  _buildInteractionButton(
                    icon: Icons.share_outlined,
                    label: '${article.shares ?? 0}',
                    onTap: () => _updateShares(article),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSponsoredCard(SponsoredContent sponsored) {
    return Card(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.orange[50]
          : Colors.orange[900]?.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.campaign, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  'Sponsored',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              sponsored.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
            ),
            SizedBox(height: 8),
            if (sponsored.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  sponsored.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 8),
            Text(
              sponsored.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Launch sponsored.targetUrl
              },
              child: Text('Learn More from ${sponsored.sponsorName}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

