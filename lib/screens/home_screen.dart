import 'package:flutter/material.dart';
import 'package:news_app_ui/models/article_model.dart';
import 'package:news_app_ui/screens/screen.dart';
import 'package:news_app_ui/services/news_service.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_tag.dart';
import '../widgets/drawer.dart';
import '../widgets/image_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final client = NewsService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: const BottomNavBar(index: 0),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: client.getNews(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final List<Article> articles = snapshot.data!;
            final headNews = articles.firstWhere(
              (article) =>
                  article.title != "" &&
                  article.urlToImage != null &&
                  article.description != "",
              orElse: () => Article(),
            );

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _NewsOfTheDay(article: headNews),
                _BreakingNews(articles: articles),
              ],
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            String errorMessage = 'Error: $error';

            return Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: Text(errorMessage),
            );
          } else {
            return const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            );
          }
        }),
      ),
    );
  }
}

//トップニュース
class _NewsOfTheDay extends StatelessWidget {
  const _NewsOfTheDay({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      imageUrl: article.urlToImage!,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      boxFit: BoxFit.cover,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTag(
            backgroundColor: Colors.black.withAlpha(150),
            children: [
              Text(
                '今日のニュース',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
            ),
            child: Text(
              article.title ?? "",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                    color: Colors.white,
                  ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                ArticleScreen.routeName,
                arguments: article,
              );
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Row(
              children: [
                Text(
                  '詳しく見る',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_right_alt,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//最新ニュース
class _BreakingNews extends StatelessWidget {
  const _BreakingNews({
    Key? key,
    required this.articles,
  }) : super(key: key);

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double boxWidth;
    if (screenWidth < 600) {
      boxWidth = MediaQuery.of(context).size.width * 0.6;
    } else if (screenWidth < 1200) {
      boxWidth = MediaQuery.of(context).size.width * 0.33;
    } else {
      boxWidth = MediaQuery.of(context).size.width * 0.25;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '最新のニュース',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                if (article.title != "" &&
                    article.author != "" &&
                    article.publishedAt != "" &&
                    article.urlToImage != null &&
                    article.content != "" &&
                    article.description != "") {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ArticleScreen.routeName,
                        arguments: articles[index],
                      );
                    },
                    child: Container(
                      width: boxWidth,
                      margin: const EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageContainer(
                            width: boxWidth,
                            height: MediaQuery.of(context).size.height * 0.25,
                            imageUrl: article.urlToImage!,
                            boxFit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            article.title ?? "",
                            maxLines: 2,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                    ),
                          ),
                          Text(
                            article.publishedAt!.split('T').first,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'by ${article.author ?? "Someone"}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
