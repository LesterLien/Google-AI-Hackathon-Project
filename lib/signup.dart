import 'package:flutter/material.dart';
import 'package:hackathonproject/form_Container_widget.dart';
import 'login.dart'; // Import the login.dart file

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sign Up"), // Change the app bar title to "Sign Up"
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text(
              "Create Account", // Change the text to "Sign Up"
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            SizedBox(height: 30),
            Text(
              "Fill in your credentials below", // Change the text to "Sign Up"
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            SizedBox(height: 5),
            FormContainerWidget(
              controller: usernameController,
              hintText: "Username",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              controller: emailController,
              hintText: "Email",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              controller: passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: _signUp, // Call _signUp function when tapped
              child: Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: isSigningUp
                      ? CircularProgressIndicator(color: Colors.white) // Use white color for CircularProgressIndicator
                      : Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login())); // Navigate to the login.dart file
                  },
                  child: Text(
                    "Login", // Change text to "Login"
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    // Perform sign up logic here...

    setState(() {
      isSigningUp = false;
    });
  }
}
