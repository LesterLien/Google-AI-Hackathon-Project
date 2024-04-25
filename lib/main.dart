import 'package:flutter/material.dart';
import 'searchPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conscious Cart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conscious Cart',
          style: TextStyle(
            fontFamily: 'Pacifico', 
            fontSize: 45, 
            fontWeight: FontWeight.bold, 
            color: Colors.black, 
          ),
        ),
        centerTitle: true, 
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10), 
          Text(
            '"Every product holds a story. Let your purchases tell tales of compassion, sustainability, and ethical values."',
            textAlign: TextAlign.center, 
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 12, 
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            ),
            child: const Text('Login'),
          ),
          SizedBox(height: 200),
          Image.network(
            'https://via.placeholder.com/150',
            height: 150, 
          ),
          SizedBox(height: 20), 
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            ),
            child: const Text('Start being Conscious about your Cart!'),
          ),
          SizedBox(height: 20), 
        ],
      ),
    );
  }
}
