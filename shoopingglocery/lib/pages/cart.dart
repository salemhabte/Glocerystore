import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import '../payment/stripe_service.dart';
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.green,
      ),
      body: cart.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                final item = cart.cartItems[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(item['image']),
                  ),
                  title: Text(item['title']),
                  subtitle: Text(
                      '\$${item['price']} x ${item['quantity']} = \$${item['price'] * item['quantity']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      cart.removeFromCart(item['id']);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${cart.getTotalPrice().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              
                // Handle checkout action
                 onPressed: () async {
          //           final totalAmount = cart.getTotalPrice().toInt();
          // StripeService.instance.makePayment(totalAmount);
          final totalAmount = cart.getTotalPrice().toInt();
                final paymentSuccess = await StripeService.instance.makePayment(totalAmount);

                if (paymentSuccess) {
                  // Clear the cart after successful payment
                  cart.clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment successful! Cart cleared.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment failed. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
        },
              
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
