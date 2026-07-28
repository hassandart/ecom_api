import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importations de vos gestionnaires d'état (Providers)
import 'package:ecom_api/feature/home/data/providers/home_provider.dart';
import 'package:ecom_api/core/providers/cart_provider.dart';

// Importation de votre interface utilisateur principale
import 'package:ecom_api/feature/home/views/home_view.dart';

void main() {
  runApp(
    // Configuration MultiProvider pour centraliser la gestion d'état de l'application
    MultiProvider(
      providers: [
        // 1. Gestionnaire d'état pour l'écran d'accueil et l'API DummyJSON
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),

        // 2. Gestionnaire d'état global pour le panier d'achat (prêt pour l'avenir)
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),

        /* Vous pourrez ajouter facilement vos futurs modules ici, exemple :
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        */
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecom Coffee App',
      debugShowCheckedModeBanner:
          false, // Masque la bande de debug en haut à droite
      theme: ThemeData(
        useMaterial3: true, // Active les composants au design Material 3
        primaryColor: const Color(0xFFC67C4E), // Couleur marron café primaire
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC67C4E),
          primary: const Color(0xFFC67C4E),
        ),
      ),
      home: const HomeView(), // Définit la vue d'accueil connectée à l'API
    );
  }
}
