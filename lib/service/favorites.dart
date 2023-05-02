import 'package:flutter/foundation.dart';

class FavoritesProvider with ChangeNotifier {
  List<String> _favorites = [];

  List<String> get favorites => _favorites;

  void addToFavorites(String recipeName) {
    if (!_favorites.contains(recipeName)) {
      _favorites.add(recipeName);
      notifyListeners();
    }
  }

  void removeFromFavorites(String recipeName) {
    if (_favorites.contains(recipeName)) {
      _favorites.remove(recipeName);
      notifyListeners();
    }
  }
}
