import 'package:ecom_api/core/shared/buttons.dart';
import 'package:ecom_api/feature/home/data/home_data_source.dart';
import 'package:ecom_api/feature/home/widgets/location_widget.dart';
import 'package:ecom_api/feature/home/widgets/my_home_banner.dart';
import 'package:ecom_api/feature/home/widgets/my_proucts_item.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeDataSource homeDataSoruce = HomeDataSource();
  int selectdCategory = 0;

  @override
  Widget build(BuildContext context) {
    // Calcul précis du tiers supérieur de l'écran pour la zone noire
    final double topSectionHeight = MediaQuery.of(context).size.height / 3;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Fond clair de la page
      body: Column(
        children: [
          // ================= ZONE FIXE SUPÉRIEURE (1/3 ÉCRAN) =================
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Bloc noir principal
              Container(
                height: topSectionHeight,
                width: double.infinity,
                color: const Color(0xFF131313),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 60,
                    ), // Évite la barre de statut (Heure, Batterie)
                    const LocationWidget(),
                    const SizedBox(height: 16),

                    // UNIQUE BOUTON DE RECHERCHE INTEGRANT LE FILTRE
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF313131),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search coffee...",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),

                          // Inclusion du bouton filtre directement à la fin du champ de recherche
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(4),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFC67C4E,
                              ), // Couleur marron café
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.tune,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () {
                                // Action de filtrage / rate
                              },
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bannière positionnée à cheval sous la recherche
              Positioned(
                bottom: -65,
                left: 24,
                right: 24,
                child: const MyHomeBanner(),
              ),
            ],
          ),

          // ================= ZONE FIXE DES CATÉGORIES =================
          Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              85,
              24,
              16,
            ), // 85px pour ne pas chevaucher la bannière
            child: SizedBox(
              height: 35,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                scrollDirection: Axis.horizontal,
                itemCount: homeDataSoruce.categories.length,
                itemBuilder: (context, index) {
                  final category = homeDataSoruce.categories[index];
                  return MyCategoryButton(
                    isSelected: category.id == selectdCategory,
                    onTap: () {
                      setState(() {
                        selectdCategory = category.id;
                      });
                    },
                    category: category,
                  );
                },
              ),
            ),
          ),

          // ================= ZONE DÉFILANTE UNIQUEMENT POUR LES PRODUITS =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                padding: const EdgeInsets.only(
                  bottom: 24,
                ), // Marge de confort tout en bas
                itemCount: homeDataSoruce.products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.7,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final prodcuts = homeDataSoruce.products[index];
                  return MyProductItem(prodcuts: prodcuts);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
