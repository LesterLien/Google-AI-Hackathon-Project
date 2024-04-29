import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'foodDetails.dart'; // Assuming this page is for detailed view
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  static Future<String?> getCurrentUserId() async {
    // Assuming user is already logged in
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
}

class FavoritesUser extends StatefulWidget {
  const FavoritesUser({super.key});

  @override
  State<FavoritesUser> createState() => _FavoritesUserState();
}

class _FavoritesUserState extends State<FavoritesUser> {
  List<Map<String, dynamic>> _favoriteFoodDetails = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  Future<void> _getFavorites() async {
    setState(() {
      _isLoading = true;
    });

    final List<String> favoriteFdcIds = await _getFavoriteFdcIds();

    List<Map<String, dynamic>> tempDetails = [];
    for (String fdcId in favoriteFdcIds) {
      try {
        final foodDetails = await _fetchFoodDetails(fdcId);
        tempDetails.add(foodDetails);
      } catch (e) {
        print("Failed to fetch details for FDC ID $fdcId: $e");
      }
    }

    setState(() {
      _favoriteFoodDetails = tempDetails;
      _isLoading = false;
    });
  }

  Future<List<String>> _getFavoriteFdcIds() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in.");
      return []; // Return an empty list if no user is logged in
    }
    final userId = user.uid;

    // Accessing the user's document in the 'favorites' collection
    final favoriteDoc =
        FirebaseFirestore.instance.collection('favorites').doc(userId);

    List<String> fdcIds = [];
    try {
      final docSnapshot = await favoriteDoc.get();
      if (docSnapshot.exists) {
        // Assuming 'foods' is the array of fdcIds
        final foods = docSnapshot.data()?['foods'] as List<dynamic>?;
        if (foods != null) {
          // Adding all fdcIds in the document to the list
          fdcIds.addAll(foods.map((fdcId) => fdcId.toString()));
        }
      }
    } catch (e) {
      print("An error occurred while fetching favorites: $e");
    }

    return fdcIds;
  }


  Future<Map<String, dynamic>> _fetchFoodDetails(String fdcId) async {
    final url = Uri.parse(
        'https://search-food-mfckn4ttpa-uc.a.run.app/searchFood?query=$fdcId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json
          .decode(response.body)[0]; // Assuming the API always returns a list
    } else {
      throw Exception('Failed to load food details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300, // Added border radius
            border: Border.all(color: Colors.black), // Added border
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Favorites',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteFoodDetails.isEmpty
              ? const Center(child: Text('No favorites yet'))
              : ListView.builder(
                  itemCount: _favoriteFoodDetails.length,
                  itemBuilder: (context, index) {
                    final foodDetails = _favoriteFoodDetails[index];
                    return ListTile(
                      title: Text(foodDetails['brandName'] ?? 'N/A'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(foodDetails['brandOwner'] ?? 'N/A'),
                          Text(foodDetails['description'] ?? 'N/A'),
                          Text('UPC: ${foodDetails['gtinUpc'] ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodDetailsPage(
                              fdcId: foodDetails['fdcId'].toString()),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
