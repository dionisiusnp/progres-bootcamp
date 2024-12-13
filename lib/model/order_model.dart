import 'dart:convert';

class Order {
  String? id;
  int? buyerId; // Perbaiki penamaan menjadi camelCase
  int? paymentMethodId; // Perbaiki penamaan menjadi camelCase
  int? totalPayment;
  bool? isDelivery; // Menggunakan bool untuk status
  bool? isPayment; // Menggunakan bool untuk status
  bool? isAccept; // Menggunakan bool untuk status
  DateTime? createdAt; // Perbaiki penamaan menjadi camelCase
  List<String>? mediaUrls;
  User? user;

  Order({
    this.id,
    this.buyerId,
    this.paymentMethodId,
    this.totalPayment,
    this.isDelivery,
    this.isPayment,
    this.isAccept,
    this.createdAt,
    this.mediaUrls,
    this.user,
  });

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map["id"],
      buyerId: map["buyer_id"],
      paymentMethodId: map["payment_method_id"],
      totalPayment: map["total_payment"] != null 
      ? int.tryParse(map["total_payment"].toString()) ?? 0 
      : 0,
      isDelivery: map["is_delivery"] == '1', // Konversi string '1' menjadi boolean
      isPayment: map["is_payment"] == '1',   // Konversi string '1' menjadi boolean
      isAccept: map["is_accept"] == '1',     // Konversi string '1' menjadi boolean
      createdAt: DateTime.parse(map["created_at"]),
      mediaUrls: map["media_urls"] != null
          ? List<String>.from(map["media_urls"].map((url) => url))
          : [], // Pastikan menggunakan List<String> yang aman
      user: map["userable"] != null ? User.fromJson(map["userable"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "payment_method_id": paymentMethodId,
      "total_payment": totalPayment,
      "is_delivery": isDelivery == true ? 1 : 0,
      "is_payment": isPayment == true ? 1 : 0,
      "is_accept": isAccept == true ? 1 : 0,
    };
  }

  @override
  String toString() {
    return 'Order{id: $id, buyerId: $buyerId, paymentMethodId: $paymentMethodId, totalPayment: $totalPayment, isDelivery: $isDelivery, isPayment: $isPayment, isAccept: $isAccept, createdAt: $createdAt}';
  }
}

class User {
  int? id;
  String? name;
  String? email;

  User({
    this.id,
    this.name,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

// Fungsi untuk mengubah JSON menjadi list Order
List<Order> orderFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Order>.from((data as List).map((item) => Order.fromJson(item)));
}

// Fungsi untuk mengubah Order menjadi JSON string
String orderToJson(Order data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
