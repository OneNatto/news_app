import '../models/article_model.dart';

abstract class NewsApiSerivce {
  Future<List<Article>> getNews();
  Future<List<Article>> getNewsByQuery(String value);
}
