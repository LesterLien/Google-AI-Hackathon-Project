import 'package:flutter/material.dart';
import 'package:hackathonproject/form_Container_widget.dart';
import 'package:hackathonproject/main.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

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
                  Spacer(),
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

    setState(() {
      isSigning = false;
    });
  }
}
