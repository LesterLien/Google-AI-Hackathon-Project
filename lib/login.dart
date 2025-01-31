import 'package:flutter/material.dart';
import 'package:hackathonproject/form_Container_widget.dart';
import 'package:hackathonproject/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathonproject/firebase/auth';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => LoginState();
}
bool _isPasswordVisible = false;
class LoginState extends State<Login> {
  bool isSigning = false;
  final FirebaseAuthService auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300, // Added border radius
              border: Border.all(color: Colors.black), // Added border
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Homepage',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 154, 164, 59)),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 15),
                  ),
                  Spacer(),
                ],
              ),
              TextFormField(
                controller: _emailController, // Assign a TextEditingController
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
              Row(
                children: [
                  Text(
                    "Password",
                    style: TextStyle(fontSize: 15),
                  ),
                  Spacer(),
                ],
              ),
              TextFormField(
                controller: _passwordController, // Assign a TextEditingController
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
                onTap: () {
                  signIn();
                },
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color.fromARGB(255, 154, 164, 59)),
                  ),
                  child: Center(
                    child: isSigning
                        ? CircularProgressIndicator(color: Color.fromARGB(255, 154, 164, 59))
                        : Text(
                            "Sign in",
                            style: TextStyle(
                              color: Color.fromARGB(255, 154, 164, 59),
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
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
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
