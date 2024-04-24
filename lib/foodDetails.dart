// foodDetails.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodDetailsPage extends StatelessWidget {
  final String fdcId;

  const FoodDetailsPage({Key? key, required this.fdcId}) : super(key: key);

  Future<Map<String, dynamic>> fetchFoodDetails() async {
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
        title: const Text('Food Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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
                  subtitle: Text(snapshot.data!['brandedFoodCategory'] ?? 'N/A'),
                ),
                ListTile(
                  title: const Text('Package Weight'),
                  subtitle: Text(snapshot.data!['packageWeight'] ?? 'N/A'),
                ),
                ListTile(
                  title: const Text('Not a Signficant Source of'),
                  subtitle: Text(snapshot.data!['notaSignificantSourceOf'] ?? 'N/A'),
                ),
                ListTile(
                  title: const Text('Ingredients'),
                  subtitle: Text(snapshot.data!['ingredients'] ?? 'N/A'),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
