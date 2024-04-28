import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Homepage"),
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
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange),
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
                decoration: InputDecoration(
                  prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8), // Adjust spacing here
                  child: Icon(Icons.email), // Add icon for password
                  ),
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true, // Set filled to true
                  fillColor: Colors.grey[250], // Specify the background color
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
              obscureText: !_isPasswordVisible, // Inverse the visibility state
              decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 10, right: 8), // Adjust spacing here
                  child: Icon(Icons.lock), // Add icon for password
                ),
                suffixIcon: IconButton(
                  icon: _isPasswordVisible
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off), // Change icon based on visibility state
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle visibility state
                    });
                  },
                ),
                filled: true, // Set filled to true
                fillColor: Colors.grey[250], // Specify the background color
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Center(
                    child: isSigning
                        ? CircularProgressIndicator(color: Colors.black)
                        : Text(
                            "Sign in",
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
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp())); 
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
