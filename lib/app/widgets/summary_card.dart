import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/kasir/controllers/kasir_controller.dart';

class SummaryCard extends StatelessWidget {
  final KasirController controller = Get.find<KasirController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Subtotal', controller.subtotal),
          const SizedBox(height: 8),
          _buildSummaryRow('Potongan Member', controller.memberDiscount),
          const Divider(),
          _buildSummaryRow('Total', controller.totalPrice, bold: true),
          const SizedBox(height: 16),
          const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              PaymentMethodIcon(icon: Icons.money, label: 'Tunai'),
              PaymentMethodIcon(icon: Icons.qr_code, label: 'QRIS'),
              PaymentMethodIcon(icon: Icons.credit_card, label: 'Debit'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, RxInt value, {bool bold = false}) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
            Text('Rp ${value.value}', style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          ],
        ));
  }
}

class PaymentMethodIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const PaymentMethodIcon({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
