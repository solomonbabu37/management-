import 'package:flutter/material.dart';
import 'package:management/Screens/catlog_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _emailControler = TextEditingController();

  final TextEditingController _passwordControler = TextEditingController();

  void _submitForm() async {
    if (_formkey.currentState?.validate() ?? false) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Login Successfully'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CatalogScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Please fill all fields correctly'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/login_top.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: Text(
                      'Login and access your account and stay conecct to your frends and family,always welcome',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    child: TextFormField(
                      controller: _emailControler,
                      decoration: InputDecoration(
                        labelText: 'Enter Email',
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email field is required';
                        } else if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}',
                        ).hasMatch(value)) {
                          return 'Enter a valid email';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: TextFormField(
                      controller: _passwordControler,
                      decoration: InputDecoration(
                        labelText: 'Enter a Password',
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be 6 charactors';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text('Or Login with', style: TextStyle()),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/google_icon.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/insta_gram.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/x.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Signup",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}