import 'package:flutter/material.dart';
import 'package:flutter_bootcamp/api/order_api.dart';
import 'package:flutter_bootcamp/buyer/buyer_screen.dart';
import 'package:flutter_bootcamp/model/auth.dart';
import 'package:flutter_bootcamp/model/config.dart';
import 'package:flutter_bootcamp/model/order_model.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Future<Map<String, dynamic>?> _lastOrderFuture;

  @override
  void initState() {
    super.initState();
    _lastOrderFuture = getLastOrder();
  }

  Future<Map<String, dynamic>?> getLastOrder() async {
    try {
      final buyerId = await Auth.getUserid();
      if (buyerId != null) {
        final order = await OrderApi().getLastOrder(buyerId);
        if (order != null) {
          return {
            'id': order.id,
            'total_payment': order.totalPayment,
          };
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _processPayment(Map<String, dynamic> order) async {
    try {
      final updatedOrder = Order(
        id: order['id'],
        totalPayment: order['total_payment'],
        paymentMethodId: 1,
        isDelivery: true,
        isPayment: true,
        isAccept: true,
      );

      final success = await OrderApi().updateOrder(updatedOrder);

      if (success) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BuyerScreen()),
            (route) => false, // Menghapus semua rute sebelumnya
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment successful!')),
          );
        }
      } else {
        throw Exception('Failed to update order.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: FutureBuilder<Map<String, dynamic>?>( 
        future: _lastOrderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No order found.'));
          }

          final order = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menambahkan padding dan border-radius untuk memperbesar tampilan card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: ${order['id']}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Bank: Bank ABC', // Nama bank ditampilkan secara statis
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Total Payment: ${Config().formatCurrency(order['total_payment'] ?? 0)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), // Customize button color
                  ),
                  onPressed: () async {
                    // Memanggil metode untuk memproses pembayaran
                    await _processPayment(order);
                  },
                  child: const Text('Proceed to Payment', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}