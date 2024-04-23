import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Conscious Cart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  Future<void> fetchFoodDetails(String fdcId) async {
    final url = Uri.parse(
        'https://get-food-details-mfckn4ttpa-uc.a.run.app/?fdcId=$fdcId');
    try {
      setState(() => _isLoading = true);
      final response = await http.get(url);
      setState(() => _isLoading = false);
      if (response.statusCode == 200) {
        final details = json.decode(response.body);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FoodDetailsPage(details: details)));
      } else {
        throw Exception('Failed to load food details');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching details: ${e.toString()}')));
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    textAlign: TextAlign.center,
                    onSubmitted: (value) => _handleSearch(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSearch,
                ),
              ],
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]['brandName'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_searchResults[index]['description'],
                          style: const TextStyle(color: Colors.grey)),
                      Text('Owned by: ${_searchResults[index]['brandOwner']}'),
                    ],
                  ),
                  onTap: () => fetchFoodDetails(
                      _searchResults[index]['fdcId'].toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FoodDetailsPage extends StatelessWidget {
  final Map<String, dynamic> details;

  const FoodDetailsPage({Key? key, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Here you would layout your details page based on the details data structure
    // For simplicity, we will just show the entire details in a pretty JSON format
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Details'),
      ),
      body: SingleChildScrollView(
        child: Text(jsonEncode(details),
            style: const TextStyle(fontFamily: 'Courier', fontSize: 14)),
      ),
    );
  }
}
