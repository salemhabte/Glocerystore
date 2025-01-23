import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Map<String, dynamic> product, int quantity) {
    // Check if the product already exists in the cart
    int index = _cartItems.indexWhere((item) => item['id'] == product['id']);
    if (index >= 0) {
      // If the product exists, update its quantity
      _cartItems[index]['quantity'] += quantity;
    } else {
      // Otherwise, add the product with its quantity
      _cartItems.add({
        ...product,
        'quantity': quantity,
      });
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item['id'] == productId);
    notifyListeners();
  }

   void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
  
  double getTotalPrice() {
    return _cartItems.fold(0, (total, item) => total + item['price'] * item['quantity']);
  }
}
