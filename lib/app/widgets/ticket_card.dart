import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketCard extends StatelessWidget {
  final String ticketName;
  final int price;
  final RxInt quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const TicketCard({
    required this.ticketName,
    required this.price,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
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
                ),
              ),
              Text(
                'Rp $price',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.blue),
                onPressed: onDecrease,
              ),
              Obx(() => Text(
                    '${quantity.value}',
                    style: const TextStyle(fontSize: 16),
                  )),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: onIncrease,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
