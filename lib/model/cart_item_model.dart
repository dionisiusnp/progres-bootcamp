class CartItem {
  final int id;
  final String orderId;
  final int productId;
  final String productName;
  final String productDescription;
  final int productPrice;
  final int productShippingCost;
  final int quantity;
  final int price;
  final int shippingCost;
  final int totalSub;

  CartItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productShippingCost,
    required this.quantity,
    required this.price,
    required this.shippingCost,
    required this.totalSub,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    try {
      final product = json['product'] ?? {};
      return CartItem(
        id: json['id'] ?? 0,
        orderId: json['order_id'] ?? '',
        productId: product['id'] ?? 0,
        productName: product['name'] ?? 'Unknown Product',
        productDescription: product['description'] ?? 'No description available',
        productPrice: product['price'] ?? 0,
        productShippingCost: product['shipping_cost'] ?? 0,
        quantity: json['quantity'] ?? 0,
        price: json['price'] ?? 0,
        shippingCost: json['shipping_cost'] ?? 0,
        totalSub: json['total_sub'] ?? 0,
      );
    } catch (e) {
      print('Error parsing CartItem: $e');
      return CartItem(
        id: 0,
        orderId: '',
        productId: 0,
        productName: 'Error Loading Product',
        productDescription: 'Error Loading Description',
        productPrice: 0,
        productShippingCost: 0,
        quantity: 0,
        price: 0,
        shippingCost: 0,
        totalSub: 0,
      );
    }
  }
}
