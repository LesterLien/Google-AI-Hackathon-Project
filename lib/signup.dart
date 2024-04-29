import 'package:flutter/material.dart';
import 'package:hackathonproject/firebase/auth';
import 'package:hackathonproject/form_Container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

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
        title: Text("Homepage"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                "Create Account",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              SizedBox(height: 30),
              Text(
                "Fill in your credentials below",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: usernameController, // Assign a TextEditingController
                decoration: InputDecoration(
                hintText: "Username",
                prefixIcon: Icon(Icons.account_box),
                filled: true, // Set filled to true
                fillColor: Colors.grey[250],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),
                  ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Set border radius // Specify the gray color
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController, // Assign a TextEditingController
                decoration: InputDecoration(
                hintText: "Enter your email",
                prefixIcon: Icon(Icons.email),
                filled: true, // Set filled to true
                fillColor: Colors.grey[250],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),
                  ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Set border radius // Specify the gray color
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController, // Assign a TextEditingController
                obscureText: !_isPasswordVisible, // Toggle password visibility
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  prefixIcon: Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.grey[250],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  suffixIcon: IconButton(
                    icon: _isPasswordVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
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
                        ? CircularProgressIndicator(color: Colors.orange)
                        : Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
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

