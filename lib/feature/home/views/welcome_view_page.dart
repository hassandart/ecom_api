import 'package:ecom_api/core/constants/image_constiant.dart';
import 'package:ecom_api/core/shared/buttons.dart';
import 'package:ecom_api/core/theme/app_theme.dart';
import 'package:ecom_api/feature/home/views/home_view.dart';
import 'package:flutter/material.dart';

class WelocmeViewPage extends StatelessWidget {
  const WelocmeViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .black, // Fond noir par défaut pour éviter les coupures visuelles
      body: Stack(
        children: [
          // 1. Image de fond sur les 2/3 supérieurs de l'écran
          Column(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(MyAppImage.welcome, fit: BoxFit.cover),
                ),
              ),
              const Expanded(
                flex: 1,
                child:
                    SizedBox(), // Remplacé le Container par un SizedBox plus léger
              ),
            ],
          ),

          // 2. Contenu textuel et bouton positionnés en bas avec défilement de sécurité
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                24,
                60,
                24,
                24,
              ), // Plus d'espace en haut pour le dégradé
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87, Colors.black],
                  stops: [0.0, 0.3, 1.0], // Dégradé plus fluide
                ),
              ),
              child: SafeArea(
                top:
                    false, // Protège uniquement le bas de l'écran (encoche/barre de navigation)
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // S'adapte strictement à la taille du contenu
                    children: [
                      const Text(
                        "Fall in Love with \nCoffee in Blissful Delight!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Welcome to our cozy coffee corner, where every cup is a delightful for you.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: MyAppColor.subTitleText,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: MyGenralButton(
                              name: "Get Started",
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeView(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
