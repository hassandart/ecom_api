import 'package:ecom_api/core/shared/buttons.dart';
import 'package:ecom_api/feature/home/data/providers/home_provider.dart';
import 'package:ecom_api/feature/home/widgets/location_widget.dart';
import 'package:ecom_api/feature/home/widgets/my_home_banner.dart';
import 'package:ecom_api/feature/home/widgets/my_proucts_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Lance le chargement initial via le Provider dès que l'écran est prêt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().initHome();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calcul précis du tiers supérieur de l'écran pour la zone noire
    final double topSectionHeight = MediaQuery.of(context).size.height / 3;

    // Écoute des changements d'état du HomeProvider
    final provider = context.watch<HomeProvider>();

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

                    // UNIQUE BOUTON DE RECHERCHE INTEGRANT LE FILTRE DYNAMIQUE
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF313131),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          // Déclenche la recherche API instantanée du provider
                          context.read<HomeProvider>().search(value);
                        },
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

                          // Alternance dynamique entre bouton "X" (effacer) et icône Filtre
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _searchController
                                          .clear(); // Vide le champ texte
                                      FocusScope.of(
                                        context,
                                      ).unfocus(); // Ferme le clavier
                                      // Réinitialise la liste par défaut de l'API
                                      context.read<HomeProvider>().initHome();
                                    });
                                  },
                                )
                              : Container(
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
                                      // Action de filtrage additionnelle si nécessaire
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
              const Positioned(
                bottom: -65,
                left: 24,
                right: 24,
                child: MyHomeBanner(),
              ),
            ],
          ),

          // ================= ZONE FIXE DES CATÉGORIES (LIÉE PROVIDER) =================
          Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              85,
              24,
              16,
            ), // 85px pour éviter le chevauchement
            child: SizedBox(
              height: 35,
              child: provider.categories.isEmpty
                  ? const Center(
                      child: LinearProgressIndicator(color: Color(0xFFC67C4E)),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.categories.length,
                      itemBuilder: (context, index) {
                        final category = provider.categories[index];
                        return MyCategoryButton(
                          isSelected:
                              category.id == provider.selectedCategoryId,
                          onTap: () {
                            context.read<HomeProvider>().selectCategory(
                              category,
                            );
                          },
                          category: category,
                        );
                      },
                    ),
            ),
          ),

          // ================= ZONE DÉFILANTE DES PRODUITS DUMMYJSON =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Builder(
                builder: (context) {
                  // 1. État de chargement initial (quand la liste est encore vide)
                  if (provider.status == HomeStatus.loading &&
                      provider.products.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC67C4E),
                      ),
                    );
                  }

                  // 2. Gestion et affichage visuel des erreurs d'API
                  if (provider.status == HomeStatus.error) {
                    return Center(
                      child: Text(
                        'Erreur : ${provider.errorMessage}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  // 3. Cas où la recherche ne trouve aucun café
                  if (provider.products.isEmpty) {
                    return const Center(
                      child: Text('Aucun café disponible ou trouvé'),
                    );
                  }

                  // 4. Affichage de la grille de produits finale issus de l'API
                  return GridView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 24,
                    ), // Confort en fin de défilement
                    itemCount: provider.products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.7,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                    itemBuilder: (context, index) {
                      final singleProduct = provider.products[index];
                      return MyProductItem(prodcuts: singleProduct);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
