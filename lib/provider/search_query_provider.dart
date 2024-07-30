import 'package:flutter_riverpod/flutter_riverpod.dart';

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
