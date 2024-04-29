import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'analysisPage.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites.dart';


class FoodDetailsPage extends StatefulWidget {
  final String fdcId;

  const FoodDetailsPage({super.key, required this.fdcId});

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  bool isFavorite = false; // Flag to track favorite state

  Future<Map<String, dynamic>> fetchFoodDetails() async {
    final url = Uri.parse(
        'https://get-food-details-mfckn4ttpa-uc.a.run.app/?fdcId=${widget.fdcId}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load food details');
    }
  }

  Future<void> _saveFavoriteState(bool isFavorite) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.fdcId}_isFavorite', isFavorite);
  }

  Future<bool> _getFavoriteState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${widget.fdcId}_isFavorite') ?? false;
  }

  void toggleFavorite() async {
    if (isFavorite) {
      await FavoritesService.unsaveFavorite(widget.fdcId);
      setState(() {
        isFavorite = false; 
      });
    } else {
      await FavoritesService.saveFavorite(widget.fdcId);
      setState(() {
        isFavorite = true; 
      });
    }
    await _saveFavoriteState(isFavorite);
  }

@override
  Widget build(BuildContext context) {
  return FutureBuilder<bool>(
    future: _getFavoriteState(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        isFavorite = snapshot.data!;
      } else {
        // Handle initial state (can be set to false)
      }
      return Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Adjust height as needed
        child: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Change to start
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300, // Added border radius
                  border: Border.all(color: Colors.black), // Added border
                ),
                height: 100, // Adjust height as needed
                alignment: Alignment.center,
                child: Text(
                  'Food Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
          body: FutureBuilder<Map<String, dynamic>>(
            future: fetchFoodDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return ListView(
                  children: <Widget>[
                    ListTile(
                      title: const Text('Item'),
                      subtitle: Text(snapshot.data!['brandName'] ?? 'N/A'),
                    ),
                ListTile(
                  title: const Text('Brand Owner'),
                  subtitle: Text(snapshot.data!['brandOwner'] ?? 'N/A'),
                ),
                ListTile(
                  title: const Text('Category'),
                  subtitle:
                      Text(snapshot.data!['brandedFoodCategory'] ?? 'N/A'),
                ),
                ListTile(
                  title: const Text('Package Weight'),
                  subtitle: Text(snapshot.data!['packageWeight'] ?? 'N/A'),
                ),
                ListTile(
                  title: const Text('Not a Signficant Source of'),
                  subtitle:
                      Text(snapshot.data!['notaSignificantSourceOf'] ?? 'N/A'),
                ),
                ListTile(
                  title: const Text('Ingredients'),
                  subtitle: Text(snapshot.data!['ingredients'] ?? 'N/A'),
                ),
                ElevatedButton(
                  // Button to navigate to AnalysisPage
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnalysisPage(fdcId: widget.fdcId)),
                    );
                  },
                  child: const Text('Analyze'),
                ),
                IconButton(
                  icon: SizedBox(
                    height: 24, // Adjust height as needed
                    width: 24, // Adjust width as needed
                    child: Image(
                      image: AssetImage(isFavorite ? 'images/favorite.png' : 'images/unfavorite.png'),
                    ),
                  ),
                  onPressed: toggleFavorite,
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
            }
          },
        ),
      );
    },
    );
  }
}

