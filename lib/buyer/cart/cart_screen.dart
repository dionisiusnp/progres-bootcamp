import 'package:flutter/material.dart';
import 'package:flutter_bootcamp/api/order_item_api.dart';
import 'package:flutter_bootcamp/buyer/payment_screen.dart';
import 'package:flutter_bootcamp/model/auth.dart';
import 'package:flutter_bootcamp/model/cart_item_model.dart';
import 'package:flutter_bootcamp/model/config.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> _cartFuture;

  @override
  void initState() {
    super.initState();
    _cartFuture = loadCartItems();
  }

  Future<List<CartItem>> loadCartItems() async {
    final buyerId = await Auth.getUserid();
    if (buyerId != null) {
      return OrderItemApi().getCart(buyerId);
    } else {
      throw Exception('User not authenticated');
    }
  }

  Future<void> _deleteItem(int itemId) async {
    final success = await OrderItemApi().deleteOrderItem(itemId);
    if (success) {
      setState(() {
        _cartFuture = loadCartItems(); // Muat ulang keranjang
      });

      final updatedCart = await _cartFuture;
      if (updatedCart.isEmpty) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Keranjang kosong.')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus item.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: FutureBuilder<List<CartItem>>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          final cartItems = snapshot.data!;
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Placeholder for product image
                      Image.asset('assets/images/produk-digital.jpeg', width: 80, height: 80, fit: BoxFit.cover),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Quantity: ${item.quantity}', style: const TextStyle(fontSize: 14)),
                            Text('Shipping: ${Config().formatCurrency(item.shippingCost)}', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                            Text('Subtotal: ${Config().formatCurrency(item.price)}', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                      Text(
                        '${Config().formatCurrency(item.totalSub)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _deleteItem(item.id); // Panggil fungsi delete
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                FutureBuilder<List<CartItem>>(
                  future: _cartFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      final total = snapshot.data!.fold(0, (sum, item) => sum + item.totalSub);
                      return Text('${Config().formatCurrency(total)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
                    } else {
                      return const Text('-');
                    }
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentScreen(),
                  ),
                );
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}