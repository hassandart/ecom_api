import 'package:ecom_api/core/constants/image_constiant.dart';
import 'package:ecom_api/core/models/products_model.dart';
import 'package:ecom_api/core/theme/app_theme.dart';
import 'package:ecom_api/feature/home/views/product_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importations indispensables de vos nouveaux composants
import 'package:ecom_api/core/providers/cart_provider.dart';

class MyProductItem extends StatelessWidget {
  const MyProductItem({super.key, required this.prodcuts});

  final ProudctsModel prodcuts;

  @override
  Widget build(BuildContext context) {
    // 1. REND LA CARTE CLIQUABLE POUR OUVRIR L'ÉCRAN DE DÉTAILS
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailView(product: prodcuts),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Flexible
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    prodcuts.image,
                    fit: BoxFit.cover,
                    // Sécurité réseau pendant le chargement
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFC67C4E),
                          strokeWidth: 2,
                        ),
                      );
                    },
                    // Sécurité en cas d'URL cassée dans l'API
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Textes descriptifs
            Text(
              prodcuts.name,
              style: MyTextStyle.normalTitleText(size: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              prodcuts.type,
              style: MyTextStyle.subTitleText(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Ligne Prix et Bouton Plus
            SizedBox(
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Zone du Prix
                  Expanded(
                    child: Text(
                      "\$ ${prodcuts.price}",
                      style: MyTextStyle.normalTitleText(size: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),

                  // Zone du bouton Plus connectée au CartProvider
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: InkWell(
                      onTap: () {
                        // 2. ACTION D'AJOUT AU PANIER VIA LE PROVIDER
                        context.read<CartProvider>().addToCart(prodcuts);

                        // Notification contextuelle de succès en bas de l'écran
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${prodcuts.name} ajouté au panier !',
                            ),
                            duration: const Duration(seconds: 1),
                            backgroundColor: const Color(0xFFC67C4E),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(MyAppIcons.plus, fit: BoxFit.contain),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
