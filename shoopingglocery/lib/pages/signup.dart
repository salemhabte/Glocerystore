import 'package:flutter/material.dart';
import '../Auth/Authservice.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
   final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _passwordStrength = ""; 
  final _authService = AuthService();
  
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

   void Signup() async {

    final email = _emailController.text;
    final password = _passwordController.text;    
    final confirmPassword = _confirmPasswordController.text;
    
    if(password != confirmPassword){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }
    
    try{

      await _authService.signUpWithEmailPassword(email, password);
      Navigator.pop(context);
    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error:" + e.toString()),
            backgroundColor: Colors.black,
          ),
        );
      }

    }
   }
   void _checkPasswordStrength(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordStrength = "";
      });
      return;
    }

    if (value.length < 6) {
      setState(() {
        _passwordStrength = "Weak: Use at least 6 characters.";
      });
    } else if (RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{6,}$').hasMatch(value) &&
           !RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:<>\./?]).{8,}$').hasMatch(value)) {
    setState(() {
      _passwordStrength = "Medium: Add special characters for a stronger password.";
    });
  
    } else if (RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:<>\./?]).{8,}$').hasMatch(value)) {
      setState(() {
        _passwordStrength = "Strong: Great job!";
      });
    } else {
      setState(() {
        _passwordStrength = "Weak: Add letters, numbers, and special characters.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color.fromARGB(255, 70, 168, 75),
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: [
          Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 133, 234, 105),
                Color.fromARGB(255, 63, 147, 67),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 80, left: 20),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Create an Account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: Colors.black.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
                            child: Column(
                              children: [
        
                                // Email Field
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your email";
                                    }
                                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
        
                                // Password Field
                                TextFormField(
                                   onChanged: (value) =>_checkPasswordStrength(value), 
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                   
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: _togglePasswordVisibility,
                                    ),
                                  ),
                                  obscureText: !_isPasswordVisible,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your password";
                                    }
                                    if (value.length < 6) {
                                      return "Password must be at least 6 characters";
                                    }
                                    return null;
                                  },
                                ),
                                
                                Text(
                                  _passwordStrength,
                                  style: TextStyle(
                                    color: _passwordStrength.contains("Weak")
                                        ? Colors.red
                                        : _passwordStrength.contains("Medium")
                                            ? Colors.orange
                                            : Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 5),
                               TextFormField(
                                  controller: _confirmPasswordController,
                                  decoration: InputDecoration(
                                    labelText: "confirmPassword",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: _togglePasswordVisibility,
                                    ),
                                  ),
                                  obscureText: !_isPasswordVisible,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your password";
                                    }
                                    if (value.length < 6) {
                                      return "Password must be at least 6 characters";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 25),
                                // Sign Up Button
                                ElevatedButton(
                                  onPressed: Signup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[400],
                                  ),
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
        
                                // Login Navigation Section
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Already A Member?",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, "login");
                                        },
                                        child: Text(
                                          "Log In",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[400],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}
