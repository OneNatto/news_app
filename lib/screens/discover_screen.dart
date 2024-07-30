import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_ui/provider/search_query_provider.dart';
import 'package:news_app_ui/screens/screen.dart';
import 'package:news_app_ui/services/news_service.dart';
import 'package:news_app_ui/widgets/image_container.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/drawer.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  static const routeName = '/discover';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> tabs = [
      '政治',
      '科学',
      'アート',
      'グルメ',
      'スポーツ',
      '健康',
    ];
    final seachText = ref.watch(searchQueryProvier);

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        drawer: const MyDrawer(),
        bottomNavigationBar: const BottomNavBar(index: 1),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const DiscoverNews(),
            if (seachText.isEmpty)
              _CategoryNews(tabs: tabs)
            else
              const _SeachedNews(),
          ],
        ),
      ),
    );
  }
}

class DiscoverNews extends ConsumerStatefulWidget {
  const DiscoverNews({Key? key}) : super(key: key);

  @override
  _DiscoverNewsState createState() => _DiscoverNewsState();
}

class _DiscoverNewsState extends ConsumerState<DiscoverNews> {
  late TextEditingController searchQueryController;

  @override
  void initState() {
    super.initState();
    searchQueryController = TextEditingController();
    searchQueryController.addListener(() {
      ref
          .read(searchQueryProvier.notifier)
          .updateSearchText(searchQueryController.text);
    });
  }

  @override
  void dispose() {
    searchQueryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvier);

    if (searchQueryController.text != searchQuery) {
      searchQueryController.text = searchQuery;
      searchQueryController.selection = TextSelection.fromPosition(
          TextPosition(offset: searchQueryController.text.length));
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ニュースを探す',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                  )),
          const SizedBox(height: 5),
          Text(
            '色々なことを知ろう',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: searchQueryController,
            decoration: InputDecoration(
              hintText: '検索する',
              fillColor: Colors.black,
              filled: true,
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryNews extends StatelessWidget {
  const _CategoryNews({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          indicatorColor: Colors.black,
          tabs: tabs
              .map((tab) => Tab(
                    icon: Text(
                      tab,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ))
              .toList(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: tabs
                .map((tab) => FutureBuilder(
                      future: NewsService().getNewsByQuery(tab),
                      builder: (context, snapshot) {
                        final articles = snapshot.data;

                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: articles!.length,
                            itemBuilder: ((context, index) {
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
                                  child: Row(
                                    children: [
                                      ImageContainer(
                                        width: 80,
                                        height: 80,
                                        imageUrl: article.urlToImage!,
                                        margin: const EdgeInsets.all(10),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(tab.toLowerCase()),
                                            Text(
                                              article.title ?? "",
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.schedule,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  article.publishedAt!
                                                      .split('T')
                                                      .first,
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                                const SizedBox(width: 20),
                                                const Icon(
                                                  Icons.visibility,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 5),
                                                const Text(
                                                  '2067views',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container(
                                child: const Text(
                                  "エラー？",
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }),
                          );
                        } else if (snapshot.hasError) {
                          return Container(
                            decoration:
                                const BoxDecoration(color: Colors.black),
                            child: Text(e.toString()),
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
                      },
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _SeachedNews extends ConsumerWidget {
  const _SeachedNews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvier);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
        future: NewsService().getNewsByQuery(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final articles = snapshot.data;
            return Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: articles!.length,
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
                        child: Row(
                          children: [
                            ImageContainer(
                              width: 80,
                              height: 80,
                              imageUrl: article.urlToImage!,
                              margin: const EdgeInsets.all(10),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    article.title ?? "",
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.schedule,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        article.publishedAt!.split('T').first,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(width: 20),
                                      const Icon(
                                        Icons.visibility,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        '2067views',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            String errorMessage = 'Error: $error';

            return Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: Text(errorMessage),
            );
          } else {
            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
