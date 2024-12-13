import 'dart:convert';

import 'package:flutter_bootcamp/model/auth.dart';
import 'package:flutter_bootcamp/model/cart_item_model.dart';
import 'package:flutter_bootcamp/model/config.dart';
import 'package:flutter_bootcamp/model/order_item_model.dart';
import 'package:http/http.dart' show Client;

class OrderItemApi {
  Client client = Client();

  Future<List<CartItem>> getCart(int buyerId) async {
    try {
      final headers = await Auth.getHeaders();
      final url = Uri.parse("${Config().baseUrl}/cart").replace(
        queryParameters: {'buyer_id': buyerId.toString()},
      );
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        return jsonResponse
            .map<CartItem>((item) => CartItem.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> createOrderItem(OrderItemModel data) async {
    final headers = await Auth.getHeaders();
    final response = await client.post(
      Uri.parse("${Config().baseUrl}/order-item"),
      headers: headers,
      body: orderitemmodelToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateOrderItem(OrderItemModel data) async {
    final response = await client.put(
      Uri.parse("${Config().baseUrl}/order-item/${data.id}"),
      headers: {"content-type": "application/json"},
      body: orderitemmodelToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteOrderItem(int id) async {
    final headers = await Auth.getHeaders();
    final response = await client.delete(
      Uri.parse("${Config().baseUrl}/order-item/$id"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}