import 'package:flutter/material.dart';
import 'package:gloceryshoping/Auth/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:gloceryshoping/pages/LandingScreen.dart';
import 'package:gloceryshoping/pages/HomePage.dart';
import './pages/cart_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import './payment/stripe_service.dart';
import './payment/consts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gloceryshoping/pages/Login.dart';
import 'package:gloceryshoping/pages/signup.dart';
void main() async {
  await _setup();
  
  await Supabase.initialize(
    url: 'https://mxpekkmmxbrzcbxupunc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14cGVra21teGJyemNieHVwdW5jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcyOTA2ODAsImV4cCI6MjA1Mjg2NjY4MH0.1hZ0VxAASwIPhl8TBr3ckITnov3cDgqZ0xHtmDa0r1g'
    );
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MyGlocery(),
    ),
  );
}
Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishedKey;
}
class MyGlocery extends StatelessWidget{
  const MyGlocery({super.key});


@override
  Widget build(BuildContext context) {
   return MaterialApp(

            debugShowCheckedModeBanner: false,
            routes: {
              "/" : (context) => const LandingScreen(),
               "login" : (context) => const Login(),
               "signup" : (context) => const Signup(),
              "home" : (context) => ProductPage(),
              "auth" : (context) => AuthGate(),
            },

   );
  }
}
