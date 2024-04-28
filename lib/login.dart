import 'package:flutter/material.dart';
import 'package:hackathonproject/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathonproject/firebase/auth';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  bool isSigning = false;
  final FirebaseAuthService auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Homepage"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Sign In",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 15),
                  ),
                  Spacer(),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 8, right: 8), // Adjust spacing here
                  child: Icon(Icons.email), // Add icon for password
                  ),
                  hintText: "Enter your email",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true, // Set filled to true
                  fillColor: Colors.grey[250], // Specify the background color
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    "Password",
                    style: TextStyle(fontSize: 15),
                  ),
                  Spacer(),
                ],
              ),
             TextFormField(
              obscureText: !_isPasswordVisible, // Inverse the visibility state
              decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10, right: 8), // Adjust spacing here
                  child: Icon(Icons.lock), // Add icon for password
                ),
                suffixIcon: IconButton(
                  icon: _isPasswordVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off), // Change icon based on visibility state
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle visibility state
                    });
                  },
                ),
                filled: true, // Set filled to true
                fillColor: Colors.grey[250], // Specify the background color
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  signIn();
                },
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Center(
                    child: isSigning
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp())); 
                    },
                    child: const Text(
                      "Sign up", // Change text to "Sign up"
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    setState(() {
      isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await auth.signInWithEmailAndPassword(email, password);


    setState(() {
      isSigning = false;
    });

    if (user != null) {
      print("User is successfully signed in");
      Navigator.pushReplacementNamed(context, "/home2");
    } else {
      print("Error");
    }
  }
}
