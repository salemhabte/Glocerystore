import 'package:dio/dio.dart';
import "./consts.dart";
import 'package:flutter_stripe/flutter_stripe.dart';
class StripeService {
StripeService._();
static final StripeService instance = StripeService._();

Future<bool> makePayment(int totalAmount) async {
  try {
    // Make payment
    String? paymentIntentClientSecret = await _createPaymentIntent(totalAmount, 'usd');
// if(paymentIntentClientSecret == null) return ;
await Stripe.instance.initPaymentSheet(
  paymentSheetParameters: SetupPaymentSheetParameters(
    paymentIntentClientSecret: paymentIntentClientSecret,
    
    merchantDisplayName: 'Glocery Store',
  ),
);
await _processPayment();
  return true;

  } catch (e) {
    
    throw Exception('Payment failed');
   
  }
}

Future<String?> _createPaymentIntent(int amount, String currency) async {
try {
  // Create payment intent
  final Dio dio = Dio();
  Map<String, dynamic> data = {
    'amount':_calculateAmount(amount),
    'currency': currency,
  };
 
 var response = await dio.post('https://api.stripe.com/v1/payment_intents', data: data,
  options: Options(
    contentType: Headers.formUrlEncodedContentType,
    headers: {
      "Authorization": "Bearer $stripeSecretKey",
      "content-type": "application/x-www-form-urlencoded",
    }),
 );
 if(response.data != null){
   
  return response.data['client_secret'];
  }
  return null;

} catch (e) {
  throw Exception('Failed to create payment intent');

}


}

Future<void> _processPayment() async {
  try {
    await Stripe.instance.presentPaymentSheet();
  } catch (e) {
    throw Exception('Payment process failed');
  }
}

String _calculateAmount(int amount){
  final calculatedAmount = amount * 100;
  return calculatedAmount.toString();
}


}