import 'package:flutter/material.dart';
import 'package:hackathonproject/form_Container_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isSigning = false;
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
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Text("Sign in"),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Text(
            "Sign In",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange), // Set text color to orange
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Text(
                "Email",
                style: TextStyle(fontSize: 15),
              ),
              Spacer(), // Add Spacer to push the text to the far left
            ],
          ),
          FormContainerWidget(
            controller: _emailController,
            hintText: "Enter your email",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                "Password",
                style: TextStyle(fontSize: 15),
              ),
              Spacer(), // Add Spacer to push the text to the far left
            ],
          ),
          FormContainerWidget(
            controller: _passwordController,
            hintText: "Enter your Password",
            isPasswordField: true,
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              signIn();
            },
            child: Container(
              width: 150, // Adjust width here
              height: 40, // Adjust height here
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange), // Orange border
              ),
              child: Center(
                child: isSigning
                    ? CircularProgressIndicator(color: Colors.black)
                    : Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.orange, // Orange text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
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

    setState(() {
      isSigning = false;
    });
  }
}
