import 'package:flutter/material.dart';
import 'searchPage.dart';
import 'package:firebase_core/firebase_core.dart';

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
            fontFamily: 'Pacifico', // Use the Pacifico font
            fontSize: 45, // Adjust font size as needed
            fontWeight: FontWeight.bold, // Optionally, set font weight
            color: Theme.of(context).textTheme.headline6!.color, // Use the text color from the theme
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch the column horizontally
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16), // Add padding around the quote
            child: Text(
              '"Every product holds a story. Let your purchases tell tales of compassion, sustainability, and ethical values."',
              textAlign: TextAlign.center, // Center the quote
              style: TextStyle(
                fontStyle: FontStyle.italic, // Optionally, set italic style for the quote
                fontSize: 16, // Optionally, adjust font size for the quote
              ),
            ),
          ),
          Image.network(
              'https://via.placeholder.com/150'), // Placeholder for logo, replace with your asset
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            ),
            child: const Text('Start being Conscious about your Cart!'),
          ),
        ],
      ),
    );
  }
}
