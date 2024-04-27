import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'foodDetails.dart'; // Import foodDetails.dart
import 'favorites.dart'; // Import FavoritesService

class FavoritesUser extends StatefulWidget {
  const FavoritesUser({Key? key}) : super(key: key);

  @override
  State<FavoritesUser> createState() => _FavoritesUserState();
}

class _FavoritesUserState extends State<FavoritesUser> {
  List<String> _favoriteFdcIds = [];

  Future<void> _getFavorites() async {
    final userId = await FavoritesService.getCurrentUserId(); // Using the local function to get the user ID
    if (userId == null) {
      return;
    }

    final favoritesRef = FirebaseFirestore.instance
        .collection(FavoritesService.favoritesCollection) // Accessing the local field
        .doc(userId);
    final favoritesSnapshot = await favoritesRef.get();

    if (favoritesSnapshot.exists) {
      setState(() {
        _favoriteFdcIds = List<String>.from(favoritesSnapshot.data()!['foods']);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: _favoriteFdcIds.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: _favoriteFdcIds.length,
              itemBuilder: (context, index) => FutureBuilder<Map<String, dynamic>>(
                future: _fetchFoodDetails(_favoriteFdcIds[index]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final foodData = snapshot.data!;
                    return ListTile(
                      title: Text(foodData['brandName'] ?? 'N/A'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(foodData['description'] ?? 'N/A'),
                          Text('UPC: ${foodData['gtinUpc'] ?? 'N/A'}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey)),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FoodDetailsPage(
                                fdcId: _favoriteFdcIds[index])),
                      ),
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
    );
  }

  Future<Map<String, dynamic>> _fetchFoodDetails(String fdcId) async {
    final url = Uri.parse(
        'https://get-food-details-mfckn4ttpa-uc.a.run.app/?fdcId=$fdcId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load food details');
    }
  }
}