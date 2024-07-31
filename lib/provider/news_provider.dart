import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_ui/repositories/news_repository.dart';
import 'package:news_app_ui/repositories/news_repository_impl.dart';
import 'package:news_app_ui/services/news_api_serivce.dart';
import 'package:news_app_ui/services/news_api_serivce_impl.dart';
import 'package:news_app_ui/viewmodels/news_view_model.dart';

import '../models/article_model.dart';

class SearchQueryNotifier extends StateNotifier<String> {
  SearchQueryNotifier() : super('');
  void updateSearchText(String value) {
    state = value;
  }
}

final searchQueryProvier =
    StateNotifierProvider<SearchQueryNotifier, String>((ref) {
  return SearchQueryNotifier();
});

final newsApiSerivceProvider =
    Provider<NewsApiSerivce>((ref) => NewsApiSerivceImpl());

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final apiService = ref.read(newsApiSerivceProvider);
  return NewsRepositoryImpl(apiService);
});

final getNewsProvider =
    StateNotifierProvider<NewsViewModel, AsyncValue<List<Article>>>((ref) {
  final repository = ref.read(newsRepositoryProvider);
  return NewsViewModel(repository);
});

final getNewsByQueryProvider = StateNotifierProvider.family<NewsViewModel,
    AsyncValue<List<Article>>, String>((ref, query) {
  final repository = ref.read(newsRepositoryProvider);
  final viewModel = NewsViewModel(repository);
  viewModel.fetchNewsByQuery(query);
  return viewModel;
});
