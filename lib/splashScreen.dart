import 'package:flutter/material.dart';
import 'package:hackathonproject/login.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});
  
  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
      Future.delayed(
        Duration(seconds: 3), (){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget.child!), (route) => false);
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Center(
        child: Text(
          "Welcome To Flutter Firebase", 
          style: TextStyle(
            color:Colors.blue, 
            fontWeight: FontWeight.bold,
            ),
            ),
      )
    );
  }
}