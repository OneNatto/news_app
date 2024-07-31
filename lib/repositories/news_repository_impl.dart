import 'package:news_app_ui/models/article_model.dart';
import 'package:news_app_ui/repositories/news_repository.dart';
import 'package:news_app_ui/services/news_api_serivce.dart';

class NewsRepositoryImpl extends NewsRepository {
  final NewsApiSerivce newsApiSerivce;

  NewsRepositoryImpl(this.newsApiSerivce);

  @override
  Future<List<Article>> getNews() async {
    return await newsApiSerivce.getNews();
  }

  @override
  Future<List<Article>> getNewsByQuery(String value) async {
    return await newsApiSerivce.getNewsByQuery(value);
  }
}
