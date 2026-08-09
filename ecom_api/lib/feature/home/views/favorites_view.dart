import 'package:ecom_api/core/providers/navigation_provider.dart';
import 'package:ecom_api/core/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecom_api/feature/home/views/product_detail_view.dart';

class FavoritesView extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const FavoritesView({super.key, this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            context.read<NavigationProvider>().setIndex(0);
          }, // 🟢 Appelle le retour à l'accueil
        ),
        title: const Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      // 🟢 ÉTAPE 1 : Envelopper le body avec un Consumer pour écouter les changements en temps réel
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favoriteProducts = favoritesProvider.favorites;

          // 🟢 ÉTAPE 2 : Si la liste est vide, afficher l'écran vide
          if (favoriteProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          // 🟢 ÉTAPE 3 : Si la liste contient des produits, afficher la ListView
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEAEAEA)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2F2D2C),
                    ),
                  ),
                  subtitle: Text(
                    'with ${product.type}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC67C4E),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // 🟢 ÉTAPE 4 : Utiliser un GestureDetector opaque pour éviter les conflits de clics
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          favoritesProvider.toggleFavorite(product);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailView(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
