import 'package:flutter/material.dart';
import 'package:hackathonproject/firebase/auth';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; 
import 'main.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuthService auth = FirebaseAuthService();

  bool isSigningUp = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 30),
              const Text(
                "Fill in your credentials below",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              const SizedBox(height: 5),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 8, right: 8), // Adjust spacing here
                  child: Icon(Icons.account_box), // Add icon for password
                  ),
                  hintText: "Enter your username",
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
                onTap: signUp,
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Center(
                    child: isSigningUp
                        ? const CircularProgressIndicator(color: Colors.orange)
                        : const Text(
                            "Sign Up",
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
                    "Already have an account? ",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login())); 
                    },
                    child: const Text(
                      "Login", // Change text to "Sign up"
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

  void signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      print("User is successfully created");
      Navigator.pushReplacementNamed(context, "/home1");
    } else {
      print("Error");
    }
  }
  
}
