import 'package:flutter_bootcamp/model/auth.dart';
import 'package:flutter_bootcamp/model/config.dart';
import 'package:flutter_bootcamp/model/order_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class OrderApi {
  Client client = Client();

  Future<List<Order>> getOrders() async {
    final headers = await Auth.getHeaders();
    final response = await client.get(Uri.parse("${Config().baseUrl}/order"),
        headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      List<dynamic> data = jsonResponse['data'];

      List<Order> orders =
          data.map<Order>((item) => Order.fromJson(item)).toList();

      return orders;
    } else {
      return [];
    }
  }

  Future<Order?> getLastOrder(int buyerId) async {
    try {
      final headers = await Auth.getHeaders();
      final url = Uri.parse("${Config().baseUrl}/last-order").replace(
        queryParameters: {'buyer_id': buyerId.toString()},
      );
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          return Order.fromJson(jsonResponse); // Pastikan data dikonversi
        } else {
          print("Invalid response format: $jsonResponse");
          return null;
        }
      } else {
        print(
            "Failed to fetch last order. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching last order: $e");
      return null;
    }
  }

  Future<bool> createOrder(Order data) async {
    // print("Creating blog with data: ${blogToJson(data)}");
    final headers = await Auth.getHeaders();
    final response = await client.post(
      Uri.parse("${Config().baseUrl}/order"),
      headers: headers,
      body: orderToJson(data),
    );

    // print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateOrder(Order data) async {
    final headers = await Auth.getHeaders();
    final response = await client.put(
      Uri.parse("${Config().baseUrl}/order/${data.id}"),
      headers: headers,
      body: orderToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteOrder(int id) async {
    final headers = await Auth.getHeaders();
    final response = await client.delete(
      Uri.parse("${Config().baseUrl}/order/$id"),
      headers: headers,
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
