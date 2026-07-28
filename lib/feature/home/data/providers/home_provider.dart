import 'package:flutter/material.dart';
import 'package:ecom_api/core/models/category_model.dart';
import 'package:ecom_api/core/models/products_model.dart';
import '../home_data_source.dart'; // Chemin relatif vers votre source de données

enum HomeStatus { initial, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  final HomeRemoteDataSource _dataSource = HomeRemoteDataSource();

  List<CategoryModel> _categories = [];
  List<ProudctsModel> _products = [];
  int _selectedCategoryId = 0;
  HomeStatus _status = HomeStatus.initial;
  String _errorMessage = '';

  List<CategoryModel> get categories => _categories;
  List<ProudctsModel> get products => _products;
  int get selectedCategoryId => _selectedCategoryId;
  HomeStatus get status => _status;
  String get errorMessage => _errorMessage;

  // Initialisation de la page
  Future<void> initHome() async {
    _status = HomeStatus.loading;
    _selectedCategoryId = 0;
    _categories = _dataSource.categories; // Correction appliquée ici
    notifyListeners();

    try {
      _products = await _dataSource.getProductsByCategory("all");
      _status = HomeStatus.loaded;
    } catch (e) {
      _status = HomeStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // Clic sur un onglet de catégorie
  Future<void> selectCategory(CategoryModel category) async {
    _selectedCategoryId = category.id;
    _status = HomeStatus.loading;
    notifyListeners();

    try {
      _products = await _dataSource.getProductsByCategory(category.slug);
      _status = HomeStatus.loaded;
    } catch (e) {
      _status = HomeStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // Saisie dans la barre de recherche
  Future<void> search(String query) async {
    _selectedCategoryId = -1;
    _status = HomeStatus.loading;
    notifyListeners();

    try {
      _products = await _dataSource.searchProducts(query);
      _status = HomeStatus.loaded;
    } catch (e) {
      _status = HomeStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
