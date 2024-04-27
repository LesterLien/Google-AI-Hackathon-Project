import 'package:flutter/material.dart';
import 'searchPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'main.dart';
import 'favoriteUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

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
        '/home1': (context) => HomePage(),
        '/home2': (context) => newHome(), 
      },
    );
  }
}

class newHome extends StatelessWidget {
  const newHome({Key? key}) : super(key: key);

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
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/home1");
            },
            child: Text("Sign out"),
          ),
          SizedBox(height:10),

          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesUser()),
            ),
            child: const Text('favorite'),
          ),
          SizedBox(height: 150),
          Image(
            image: AssetImage('images/logo.png'),
            
            fit: BoxFit.cover, 
            width: 200, 
            height: 200, 
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
