import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'searchPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'favoriteUser.dart';
import 'instructionPage.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 154, 164, 59),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Conscious Cart',
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(207, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '"Every product holds a story. Let your purchases tell tales of compassion, sustainability, and ethical values."',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 154, 164, 59),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, "/home1");
                          },
                          child: const Text('Sign out', style: TextStyle(color: Colors.black),),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 135, 178, 166)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FavoritesUser()),
                          ),
                          child: const Text('Favorite', style: TextStyle(color: Colors.black),),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 135, 178, 166)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const InstructionPage()),
                          ),
                          child: const Text('Instruction', style: TextStyle(color: Colors.black),),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 135, 178, 166)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Image(
                  image: AssetImage('images/logo.png'),
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              ],
            ),
            const SizedBox(height: 100),
            Center( // Center the button horizontally
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), // Added black border
                  borderRadius: BorderRadius.circular(40), // Added border radius
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 254, 249, 224)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0), // Adjust padding as needed
                    child: const Text(
                      'Be Cart-Conscious!',
                      style: TextStyle(color: Colors.black, fontSize: 20),
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
}
