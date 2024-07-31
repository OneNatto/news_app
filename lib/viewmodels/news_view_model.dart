import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_ui/repositories/news_repository.dart';
import '../models/article_model.dart';

class NewsViewModel extends StateNotifier<AsyncValue<List<Article>>> {
  final NewsRepository repository;

  NewsViewModel(this.repository) : super(const AsyncValue.loading()) {
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final articles = await repository.getNews();
      state = AsyncValue.data(articles);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> fetchNewsByQuery(String query) async {
    try {
      state = const AsyncValue.loading();
      final articles = await repository.getNewsByQuery(query);
      state = AsyncValue.data(articles);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
