import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  String _selectedMethod =
      'COD'; // Par défaut : Paiement à la livraison (Maroc)
  bool _isLoading = false;

  // Getters
  String get selectedMethod => _selectedMethod;
  bool get isLoading => _isLoading;

  void changePaymentMethod(String method) {
    _selectedMethod = method;
    notifyListeners();
  }

  void resetStatus() {
    _isLoading = false;
    notifyListeners();
  }

  // 🟢 AJOUTEZ CETTE MÉTHODE EXACTE POUR CORRIGER L'ERREUR
  Future<bool> processOrder({required double amount}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simule un traitement réseau (appel API fictif) de 2 secondes
      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
      return true; // Retourne true si la commande est validée
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
