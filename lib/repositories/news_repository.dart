import '../models/article_model.dart';

abstract class NewsRepository {
  Future<List<Article>> getNews();
  Future<List<Article>> getNewsByQuery(String value);
}
