import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketCard extends StatelessWidget {
  final String ticketName;
  final int price;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final RxInt quantity;

  const TicketCard({
    super.key,
    required this.ticketName,
    required this.price,
    required this.onIncrease,
    required this.onDecrease,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticketName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$price',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onDecrease,
                  icon: const Icon(Icons.remove),
                ),
                Obx(() => Text(
                      '${quantity.value}', // Bind quantity to the UI
                      style: const TextStyle(fontSize: 16),
                    )),
                IconButton(
                  onPressed: onIncrease,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
