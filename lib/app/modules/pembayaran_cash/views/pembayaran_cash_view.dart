import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PembayaranCashView extends StatefulWidget {
  @override
  _PembayaranCashViewState createState() => _PembayaranCashViewState();
}

class _PembayaranCashViewState extends State<PembayaranCashView> {
  final TextEditingController _controller = TextEditingController();
  double totalAmount = 100000.0; // For example, total order amount

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pembayaran Cash',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
        ),
        titleSpacing: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Masukkan nominal uang yang diterima:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                hintText: 'Rp 0',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                double receivedAmount =
                    double.tryParse(_controller.text) ?? 0.0;
                double change = receivedAmount - totalAmount;

                // Tampilkan modal untuk jumlah kembalian
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Kembalian'),
                    content: Text(
                      'Kembalian: Rp ${NumberFormat.currency(locale: 'id', symbol: 'Rp').format(change)}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Proses Pembayaran',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff181681), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Adjust the radius here
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
