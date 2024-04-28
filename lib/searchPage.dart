// searchPage.dart
import 'package:flutter/material.dart';
import 'foodDetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  

  Future<void> searchFood(String query) async {
    final url = Uri.parse(
        'https://search-food-mfckn4ttpa-uc.a.run.app/searchFood?query=$query');
    try {
      setState(() => _isLoading = true);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _searchResults = List<Map<String, dynamic>>.from(
            data.map((item) => Map<String, dynamic>.from(item)));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleSearch() {
    if (_searchController.text.isNotEmpty) {
      searchFood(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Foods'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search for food',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) => _handleSearch(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_searchResults[index]['brandName']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_searchResults[index]['brandOwner']),
                    Text(_searchResults[index]['description']),
                    Text('UPC: ${_searchResults[index]['gtinUpc']}',
                        style: TextStyle(
                            fontSize: 12,
                            color:
                                Colors.grey)) // Displaying UPC in smaller text
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FoodDetailsPage(
                          fdcId: _searchResults[index]['fdcId'].toString())),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
