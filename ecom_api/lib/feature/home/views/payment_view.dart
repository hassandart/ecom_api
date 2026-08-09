import 'package:ecom_api/feature/home/data/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecom_api/core/providers/cart_provider.dart';
// 🟢 ÉTAPE 1 : Alignement de l'import sur la structure Core/Providers

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().resetStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final double totalAmount = cartProvider.totalPrice > 0
        ? cartProvider.totalPrice
        : 4.50;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'Mode de Paiement',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: paymentProvider.isLoading
              ? null
              : () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Choisissez votre moyen de règlement au Maroc :',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // 🟢 ÉTAPE 2 : Vos deux lignes de paiement épurées
            _buildPaymentMethodTile(
              id: 'COD',
              title: 'Paiement à la livraison',
              subtitle: 'Payez en espèces dès réception de votre café',
              icon: Icons.delivery_dining_outlined,
              provider: paymentProvider,
            ),
            const SizedBox(height: 16),

            _buildPaymentMethodTile(
              id: 'CASH_AGENCY',
              title: 'Wafacash / Cash Plus',
              subtitle: 'Payez en espèces dans l’agence de votre choix',
              icon: Icons.storefront_outlined,
              provider: paymentProvider,
            ),

            const SizedBox(height: 40),
            _buildSubmitButton(paymentProvider, totalAmount, cartProvider),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS COMPOSANTS ---

  Widget _buildPaymentMethodTile({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required PaymentProvider provider,
  }) {
    final isSelected = provider.selectedMethod == id;

    return GestureDetector(
      onTap: () => provider.changePaymentMethod(id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC67C4E)
                : const Color(0xFFEAEAEA),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected ? const Color(0xFFC67C4E) : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF2F2D2C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // 🟢 ÉTAPE 3 : Remplacement du lourd RadioGroup par un simple indicateur circulaire d'état natif
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFC67C4E) : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC67C4E),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
    PaymentProvider paymentProvider,
    double totalAmount,
    CartProvider cartProvider,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC67C4E),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(
            0xFFC67C4E,
          ).withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: paymentProvider.isLoading
            ? null
            : () async {
                // 🟢 ÉTAPE 4 : Vérifier que votre PaymentProvider possède bien processOrder (ou processPayment)
                bool success = await paymentProvider.processOrder(
                  amount: totalAmount,
                );
                if (mounted && success) {
                  cartProvider.clearCart(); // Vide le panier après l'achat
                  _showSuccessDialog(paymentProvider);
                }
              },
        child: paymentProvider.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Confirmer la commande',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  // 🟢 ÉTAPE 5 : Finalisation propre de votre boîte de dialogue (sans barres jaunes d'overflow)
  void _showSuccessDialog(PaymentProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  provider.selectedMethod == 'COD'
                      ? 'Commande Reçue !'
                      : 'Demande Enregistrée !',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          content: Text(
            provider.selectedMethod == 'COD'
                ? 'Votre commande de café a été validée. Préparez vos espèces pour la livraison.'
                : 'Veuillez vous rendre dans une agence Wafacash ou Cash Plus pour finaliser le règlement.',
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
                Navigator.of(
                  context,
                ).pop(); // Quitte la page de paiement vers les détails
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFC67C4E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
