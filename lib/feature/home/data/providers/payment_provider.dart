import 'package:flutter/material.dart';

enum PaymentStatus { initial, loading, success, error }

class PaymentProvider with ChangeNotifier {
  PaymentStatus _status = PaymentStatus.initial;

  // Méthode par défaut au Maroc : Paiement à la livraison
  String _selectedMethod = 'COD'; // COD = Cash On Delivery
  String _paymentCode = ''; // Code généré si choix Wafacash / Cash Plus

  PaymentStatus get status => _status;
  String get selectedMethod => _selectedMethod;
  String get paymentCode => _paymentCode;
  bool get isLoading => _status == PaymentStatus.loading;

  void changePaymentMethod(String method) {
    _selectedMethod = method;
    notifyListeners();
  }

  void resetStatus() {
    _status = PaymentStatus.initial;
    _paymentCode = '';
  }

  // Validation de la commande selon le mode choisi
  Future<bool> processOrder({required double amount}) async {
    _status = PaymentStatus.loading;
    notifyListeners();

    try {
      // Simulation d'un appel API vers votre serveur backend (2 secondes)
      await Future.delayed(const Duration(milliseconds: 2000));

      if (_selectedMethod == 'CASH_AGENCY') {
        // Simulation d'un code de paiement à 8 chiffres pour Wafacash/Cash Plus
        _paymentCode = '4829 1056';
      }

      _status = PaymentStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = PaymentStatus.error;
      notifyListeners();
      return false;
    }
  }
}
