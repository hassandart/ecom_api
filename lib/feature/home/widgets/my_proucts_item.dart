import 'package:ecom_api/core/constants/image_constiant.dart';
import 'package:ecom_api/core/models/products_model.dart';
import 'package:ecom_api/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MyProductItem extends StatelessWidget {
  const MyProductItem({super.key, required this.prodcuts});

  final ProudctsModel prodcuts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Image Flexible (S'adapte automatiquement sans déborder)
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(prodcuts.image, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 2. Textes descriptifs
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
          const SizedBox(height: 4), // Réduit de 8 à 4 pour gagner de la place
          // 3. Ligne Prix et Bouton Plus verrouillée en hauteur
          SizedBox(
            height:
                36, // Hauteur fixe stricte pour forcer l'alignement vertical sans déborder
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

                // Zone du bouton Plus forcée en taille fixe
                SizedBox(
                  width: 32,
                  height: 32,
                  child: InkWell(
                    onTap: () {
                      // Action d'ajout au panier
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      MyAppIcons.plus,
                      fit: BoxFit
                          .contain, // Empêche l'icône de flotter hors du cadre
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
