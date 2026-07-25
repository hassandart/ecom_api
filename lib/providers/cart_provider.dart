import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    try {
      // Récupère toutes les lignes de la table 'products' sur Supabase
      final data = await _supabase.from('products').select();
      _products = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('Erreur lors du chargement des produits : $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
