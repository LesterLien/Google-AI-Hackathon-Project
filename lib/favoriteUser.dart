import 'package:flutter/material.dart';
import 'foodDetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favorites.dart';

class FavoritesUser extends StatefulWidget {
  const FavoritesUser({Key? key}) : super(key: key);

  @override
  State<FavoritesUser> createState() => _FavoritesUserState();
}

class _FavoritesUserState extends State<FavoritesUser> {
  List<String> _favoriteFdcIds = [];
  List<Map<String, dynamic>> _favoriteFoodDetails = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  Future<void> _getFavorites() async {

    final List<String> favoriteFdcIds = await _getFavoriteFdcIds();

    setState(() {
      _favoriteFdcIds = favoriteFdcIds;
      _isLoading = true;
    });


    await Future.forEach<String>(_favoriteFdcIds, (String fdcId) async {
      final foodDetails = await _fetchFoodDetails(fdcId);
      setState(() {
        _favoriteFoodDetails.add(foodDetails);
      });
    });

    setState(() {
      _isLoading = false;
    });
  }

Future<List<String>> _getFavoriteFdcIds() async {
  final userId = await FavoritesService.getCurrentUserId();
  if (userId == null) {
    return []; // Return empty list if user is not logged in
  }

  final favoritesRef = FirebaseFirestore.instance
      .collection(FavoritesService.favoritesCollection)
      .doc(userId);

  final favoritesSnapshot = await favoritesRef.get();
  if (favoritesSnapshot.exists) {
    final List<dynamic> foods = favoritesSnapshot.data()?['foods'] ?? [];
    return foods.map((food) => food.toString()).toList();
  } else {
    return []; 
  }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteFdcIds.isEmpty
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
                          Text(foodDetails['description'] ?? 'N/A'),
                          Text('UPC: ${foodDetails['gtinUpc'] ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey)),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodDetailsPage(
                            fdcId: _favoriteFdcIds[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
