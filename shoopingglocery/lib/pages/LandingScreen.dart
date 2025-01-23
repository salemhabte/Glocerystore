import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
 // Updated to "LandingScreen"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/land.png",
            height: 300,),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Text("Buy Fresh Groceries", style: TextStyle(
                color: Color(0xFF00A368),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
              ),
            ) ,
            const SizedBox(height:50),

            InkWell(
             

              onTap: () {
                Navigator.pushReplacementNamed(context, "auth");
              },
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16 ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFF00A368),
                ),
              child: const Text("Get Started",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,

              ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
