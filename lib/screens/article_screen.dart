import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app_ui/models/article_model.dart';
import 'package:news_app_ui/widgets/custom_tag.dart';
import 'package:news_app_ui/widgets/image_container.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  static const routeName = '/article';

  @override
  Widget build(BuildContext context) {
    final article = ModalRoute.of(context)!.settings.arguments as Article;

    return ImageContainer(
      width: double.infinity,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      imageUrl: article.urlToImage!,
      boxFit: BoxFit.fitWidth,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            _NewsHead(article: article),
            _NewsBody(article: article),
          ],
        ),
      ),
    );
  }
}

//
//
//
//
//
//Newshead

class _NewsHead extends StatelessWidget {
  const _NewsHead({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double boxHeight;

    if (screenWidth < 600) {
      boxHeight = MediaQuery.of(context).size.height * 0.05;
    } else if (screenWidth < 1200) {
      boxHeight = MediaQuery.of(context).size.height * 0.2;
    } else {
      boxHeight = MediaQuery.of(context).size.height * 0.25;
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: boxHeight),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title!,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.25,
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _NewsBody extends StatelessWidget {
  const _NewsBody({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    String? publishedTime;
    if (article.publishedAt != null) {
      DateTime dateTime = DateTime.parse(article.publishedAt!);
      publishedTime = DateFormat('yyyy年M月d日').format(dateTime);
    }

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (article.author != null)
                  CustomTag(
                    backgroundColor: article.author == null
                        ? Colors.transparent
                        : Colors.grey.shade200,
                    children: [
                      Text(
                        article.author ?? "",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                const SizedBox(width: 10),
                if (publishedTime != null)
                  CustomTag(
                    backgroundColor: Colors.grey.shade200,
                    children: [
                      const Icon(
                        Icons.timer,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        publishedTime,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                const SizedBox(width: 10),
                CustomTag(
                  backgroundColor: Colors.grey.shade200,
                  children: [
                    const Icon(
                      Icons.remove_red_eye,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '2469views',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            article.title!,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            article.description!,
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.5),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
