import 'package:dio/dio.dart';
import 'package:ecom_api/core/models/category_model.dart';
import 'package:ecom_api/core/models/products_model.dart';

class HomeRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // GETTER UNIFIÉ : Plus de "getStaticCategories"
  List<CategoryModel> get categories => [
    CategoryModel(id: 0, name: "All Products", slug: "all"),
    CategoryModel(id: 1, name: "Groceries", slug: "groceries"),
    CategoryModel(id: 2, name: "Laptops", slug: "laptops"),
    CategoryModel(id: 3, name: "Fragrances", slug: "fragrances"),
  ];

  // Chargement des produits par catégorie
  Future<List<ProudctsModel>> getProductsByCategory(String categorySlug) async {
    try {
      final String path = categorySlug == "all"
          ? '/products'
          : '/products/category/$categorySlug';

      final response = await _dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'];
        return productsJson
            .map((json) => ProudctsModel.fromJson(json))
            .toList();
      }
      throw Exception('Erreur de chargement des produits');
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  // Recherche de produits
  Future<List<ProudctsModel>> searchProducts(String query) async {
    try {
      if (query.isEmpty) {
        return getProductsByCategory("all");
      }

      final response = await _dio.get(
        '/products/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'];
        return productsJson
            .map((json) => ProudctsModel.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la recherche');
    } catch (e) {
      throw Exception('Erreur de recherche : $e');
    }
  }
}
