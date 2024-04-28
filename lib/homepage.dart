import 'package:flutter/material.dart';
import 'searchPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'favoriteUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conscious Cart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const newHome(),
      routes: {
        '/home1': (context) => const HomePage(),
        '/home2': (context) => const newHome(), 
      },
    );
  }
}

class newHome extends StatelessWidget {
  const newHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
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
          const SizedBox(height: 10), 
          const Text(
            '"Every product holds a story. Let your purchases tell tales of compassion, sustainability, and ethical values."',
            textAlign: TextAlign.center, 
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 12, 
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/home1");
            },
            child: const Text("Sign out"),
          ),
          const SizedBox(height:10),

          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesUser()),
            ),
            child: const Text('Favorite'),
          ),
          const SizedBox(height: 50),
          const Image(
            image: AssetImage('images/logo.png'),
            fit: BoxFit.cover, 
            width: 200, 
            height: 200, 
          ),
          const SizedBox(height: 20), 
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            ),
            child: const Text('Start being Conscious about your Cart!'),
          ),
          const SizedBox(height: 20), 
        ],
      ),
    );
  }
}
