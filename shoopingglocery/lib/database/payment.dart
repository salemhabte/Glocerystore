import 'package:flutter/material.dart';
import 'package:gloceryshoping/Auth/Authservice.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Paymentdb{

  final _authService = AuthService();
  final db = Supabase.instance.client.from('Payment');

  Future<void> add(int amount) async {
    String? userEmail = _authService.getCurrentUserEmail();

    if (userEmail != null) {
      await db.insert([{'user': userEmail, 'amount': amount}]);
    } else {
      throw Exception('User email not available');
    }
  }
}