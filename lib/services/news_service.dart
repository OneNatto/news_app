import 'dart:math';

import 'package:dio/dio.dart';
import 'package:news_app_ui/models/article_model.dart';

import '../data/my_data.dart';

class NewsService {
  final _dio = Dio(BaseOptions(
    baseUrl: ApiUrls.baseUrl,
    responseType: ResponseType.json,
  ));

  Future<List<Article>> getNews() async {
    var response = await _dio.get('/getNews');

    if (response.statusCode == 200) {
      final List<dynamic> body = response.data['articles'];

      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      throw (e);
    }
  }

  //検索したら、そのワードでApi通信
  Future<List<Article>> getNewsByQuery(String value) async {
    final response =
        await _dio.get('/getNewsByQuery', queryParameters: {'q': value});

    if (response.statusCode == 200) {
      final List<dynamic> body = response.data['articles'];

      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      throw (e);
    }
  }
}
