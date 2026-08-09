import 'package:flutter/material.dart';
import 'package:ecom_api/core/models/products_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<ProudctsModel> _favorites = [];
  bool _hasSeenFavorites = false;

  // 🌍 Getters
  List<ProudctsModel> get favorites => _favorites;
  int get badgeCount => _hasSeenFavorites ? 0 : _favorites.length;

  // 🔍 Vérifie la présence d'un produit par ID
  bool isFavorite(ProudctsModel product) {
    return _favorites.any((item) => item.id == product.id);
  }

  // 📢 Marquer les favoris comme lus
  void markAsRead() {
    if (!_hasSeenFavorites) {
      _hasSeenFavorites = true;
      notifyListeners();
    }
  }

  // 🔁 Ajouter / Supprimer des favoris
  void toggleFavorite(ProudctsModel product) {
    final isExist = isFavorite(product);

    if (isExist) {
      _favorites.removeWhere((item) => item.id == product.id);
    } else {
      _favorites.add(product);
      _hasSeenFavorites = false; // Réactive le badge lors d'un nouvel ajout
    }
    notifyListeners();
  }
}
