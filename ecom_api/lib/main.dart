import 'package:ecom_api/core/providers/navigation_provider.dart';
import 'package:ecom_api/feature/home/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 IMPORTATION INDISPENSABLE pour gérer l'orientation
import 'package:provider/provider.dart';
import 'package:ecom_api/core/providers/favorites_provider.dart';

// Importations de vos gestionnaires d'état (Providers)
import 'package:ecom_api/feature/home/data/providers/home_provider.dart';
import 'package:ecom_api/core/providers/cart_provider.dart';

// Importation de votre interface utilisateur principale

import 'feature/home/data/providers/payment_provider.dart';

void main() async {
  // 1. Assure l'initialisation complète des liaisons Flutter avant l'appel système
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Bloque l'application STRICTEMENT en mode Portrait (Haut et Bas)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    // Configuration MultiProvider pour centraliser la gestion d'état de l'application
    MultiProvider(
      providers: [
        // 1. Gestionnaire d'état pour l'écran d'accueil et l'API DummyJSON
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),

        // 2. Gestionnaire d'état global pour le panier d'achat (prêt pour l'avenir)
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),

        /* Vous pourrez ajouter facilement vos futurs modules ici, exemple :
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        */
        ChangeNotifierProvider<PaymentProvider>(
          create: (_) => PaymentProvider(),
        ),
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
      home: const MainScreen(), // Définit la vue d'accueil connectée à l'API
    );
  }
}
