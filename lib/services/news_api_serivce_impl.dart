import 'package:dio/dio.dart';
import 'package:news_app_ui/models/article_model.dart';
import 'package:news_app_ui/services/news_api_serivce.dart';

import '../data/my_data.dart';

class NewsApiSerivceImpl extends NewsApiSerivce {
  final _dio = Dio(BaseOptions(
    baseUrl: ApiUrls.baseUrl,
    responseType: ResponseType.json,
  ));

  @override
  Future<List<Article>> getNews() async {
    var response = await _dio.get('/getNews');
    if (response.statusCode == 200) {
      final List<dynamic> body = response.data['articles'];
      return body.map((dynamic item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('ニュースの取得に失敗しました');
    }
  }

  @override
  Future<List<Article>> getNewsByQuery(String value) async {
    final response =
        await _dio.get('/getNewsByQuery', queryParameters: {'q': value});
    if (response.statusCode == 200) {
      final List<dynamic> body = response.data['articles'];
      return body.map((dynamic item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('ニュースの取得に失敗しました');
    }
  }
}
