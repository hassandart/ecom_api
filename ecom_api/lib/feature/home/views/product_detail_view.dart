import 'package:ecom_api/core/providers/favorites_provider.dart';
import 'package:ecom_api/feature/home/views/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecom_api/core/models/products_model.dart';
import 'package:ecom_api/core/providers/cart_provider.dart';

class ProductDetailView extends StatefulWidget {
  final ProudctsModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  // État local pour la taille du café sélectionné
  int quantity = 1;
  String selectedSize = 'M';

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              // 🔍 On vérifie si ce produit précis est déjà en favori
              final isFav = favoritesProvider.isFavorite(product);

              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav
                      ? Colors.red
                      : Colors.black, // Devient rouge si favori
                ),
                onPressed: () {
                  // 🔁 Ajoute ou supprime des favoris instantanément
                  favoritesProvider.toggleFavorite(product);
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ZONE DÉFILANTE : Infos du produit
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Image principale du café avec angles arrondis
                  // Image principale du café avec angles arrondis
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 1 / 1, // 👈 Format carré parfait
                        child: Image.network(
                          product.image, // Ou product.image selon votre modèle
                          width: double.infinity,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          errorBuilder: (_, _, _) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              size: 45,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Titre et type
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2D2C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'with ${product.type}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Ligne de Note (Rating)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 22),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rate}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' (${(product.rate * 10).toInt()} reviews)',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32, thickness: 1),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2D2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F2D2C),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFEAEAEA)),
                        ),
                        child: Row(
                          children: [
                            // Bouton Moins (-)
                            IconButton(
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null, // Désactivé si la quantité est à 1
                              icon: const Icon(Icons.remove, size: 18),
                              color: const Color(0xFFC67C4E),
                            ),
                            // Affichage du chiffre de la quantité
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2F2D2C),
                              ),
                            ),
                            // Bouton Plus (+)
                            IconButton(
                              onPressed: () => setState(() => quantity++),
                              icon: const Icon(Icons.add, size: 18),
                              color: const Color(0xFFC67C4E),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Sélection des Tailles (S, M, L)
                  const Text(
                    'Size',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2D2C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['S', 'M', 'L'].map((size) {
                      final isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSize = size),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.8,
                          height: 45,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFFF5EE)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFC67C4E)
                                  : const Color(0xFFEAEAEA),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              size,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFFC67C4E)
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ZONE FIXE INFERIEURE : Prix et Bouton d'achat
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Section Prix
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      // ⬇️ Calcul dynamique du prix total
                      Text(
                        '\$ ${(product.price * quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC67C4E),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 40),
                  // Bouton Ajouter au panier connecté au CartProvider
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFC67C4E,
                          ), // Marron café
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),

                        onPressed: () {
                          debugPrint("1. 🔥 Clic détecté sur Buy Now");

                          try {
                            final cart = Provider.of<CartProvider>(
                              context,
                              listen: false,
                            );

                            // On ajoute le produit au panier
                            cart.addToCart(widget.product);
                            debugPrint(
                              "2. ✅ Produit ajouté au panier avec succès !",
                            );

                            // Force la navigation vers la vue du paiement
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PaymentView(),
                              ),
                            );
                            debugPrint(
                              "3. 🚀 Navigation vers PaymentView lancée",
                            );
                          } catch (e) {
                            // 🔴 Si une erreur se produit dans CartProvider, elle s'affichera ici sans bloquer l'app
                            debugPrint(
                              "❌ Erreur attrapée dans le processus d'achat : $e",
                            );

                            // Par sécurité, on force quand même la navigation pour ne pas bloquer l'utilisateur
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PaymentView(),
                              ),
                            );
                          }
                        },

                        child: const Text(
                          'Buy Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
