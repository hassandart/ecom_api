import 'package:flutter/material.dart';
import 'package:ecom_api/core/models/products_model.dart';

// Une petite classe locale pour stocker le produit associé à sa quantité
class CartItem {
  final ProudctsModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  // Liste interne des éléments du panier
  final List<CartItem> _items = [];

  // Expose la liste au reste de l'application
  List<CartItem> get items => _items;

  // Calcul du nombre total d'articles dans le panier
  int get totalItemsCount {
    int total = 0;
    for (var item in _items) {
      total += item.quantity;
    }
    return total;
  }

  // Calcul du prix total du panier
  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  // Ajouter un produit au panier (ou augmenter sa quantité s'il existe déjà)
  void addToCart(ProudctsModel product) {
    // Vérifie si le produit est déjà présent dans la liste
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      // Si oui, on augmente simplement la quantité
      _items[index].quantity++;
    } else {
      // Si non, on ajoute un nouvel élément
      _items.add(CartItem(product: product));
    }
    notifyListeners(); // Alerte l'UI pour mettre à jour les badges et les prix
  }

  // Diminuer la quantité ou retirer le produit si la quantité tombe à 0
  void removeOneFromCart(ProudctsModel product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Supprimer complètement un produit de la liste, peu importe sa quantité
  void removeItemCompletely(ProudctsModel product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  // Vider entièrement le panier après une commande
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
