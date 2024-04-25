import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalysisPage extends StatefulWidget {
  final String fdcId;

  AnalysisPage({Key? key, required this.fdcId}) : super(key: key);

  @override
  _AnalysisPageState createState() => _AnalysisPageState(fdcId: fdcId);
}

class _AnalysisPageState extends State<AnalysisPage> {
  late Future<Map<String, dynamic>> _analysisResult;

  final String fdcId;

  _AnalysisPageState({required this.fdcId});

  @override
  void initState() {
    super.initState();
    _analysisResult = _fetchAnalysis();
  }

  Future<Map<String, dynamic>> _fetchAnalysis() async {
    final uri = Uri.parse(
        'https://generate-food-analysis-mfckn4ttpa-uc.a.run.app/generate_food_analysis?fdcId=$fdcId');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return _parseAnalysisData(data); // Parse the data before returning
      } else {
        throw Exception(
            'Failed to load analysis (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching analysis: $e');
      throw Exception('Failed to fetch analysis');
    }
  }

  Map<String, dynamic> _parseAnalysisData(Map<String, dynamic> rawData) {
    return {
      'Brand': rawData['Brand'],
      'Ingredients': _parseList(rawData['Ingredients']),
      'Potential Allergens': _parseList(rawData['Potential Allergens']),
      'Health Evaluation': rawData['Health Evaluation'],
      'Positives': _parseList(rawData['Positives']),
      'Negatives': _parseList(rawData['Negatives']),
      'Considerations': _parseList(rawData['Considerations']),
      'Disclaimers': _parseList(rawData['Disclaimers']),
      'Dietary Suitability':
          _parseDietarySuitability(rawData['Dietary Suitability']),
      'Diabetic': _parseList(rawData['Diabetic']),
      'Overall Analysis': _parseList(rawData['Overall Analysis']),
    };
  }

  dynamic _parseDietarySuitability(dynamic data) {
    if (data is Map<String, dynamic>) {
      return {
        'Vegan': data['Vegan'],
        'Vegetarian': data['Vegetarian'],
        'Gluten-Free': data['Gluten-Free'],
        'Keto': data['Keto'],
      };
    } else {
      return data; // If it's not a map, return as is
    }
  }

  List<String> _parseList(dynamic data) {
  if (data is List<dynamic>) {
    return data.map((item) => item.toString()).toList();
  } else if (data is String) {
    // Strip out the "- [" at the start and "- ]" at the end if present.
    String formattedString = data.replaceAll(RegExp(r'^\-\s*\[|\]\s*\-\s*$'), '');
    // Now, remove square brackets if they're at the ends of the string.
    formattedString = formattedString.replaceAll(RegExp(r'^\[|\]$'), '');
    // Split the string by the comma, then strip each item of whitespace and quotes.
    return formattedString.split(RegExp(r'\s*\,\s*')).map((item) => item.replaceAll(RegExp(r'^"|"$'), '')).toList();
  } else {
    return [data.toString()];
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Analysis'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _analysisResult,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final analysisData = snapshot.data!;
            // Access the values from the map and display them in your UI
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Brand: ${analysisData['Brand']}'),
                  Text('Ingredients: ${_parseList(analysisData['Ingredients']).join(', ')}'),
                  Text('Potential Allergens: ${_parseList(analysisData['Potential Allergens']).join(',')}'),
                  Text('Health Evaluation:'),
                  for (var positive in analysisData['Positives'])
                    Text('  - $positive'),
                  for (var negative in analysisData['Negatives'])
                    Text('  - $negative'),
                  Text('Considerations: ${_parseList(analysisData['Considerations']).join(', ')}'),
                  for (var consideration in _parseList(analysisData['Considerations']))
                    Text('  - $consideration'),
                  Text('Disclaimers:'),
                  for (var disclaimer in analysisData['Disclaimers'])
                    Text('  - $disclaimer'),
                  Text('Dietary Suitability:'),
                  if (analysisData['Dietary Suitability']
                      is Map<String, dynamic>) ...[
                    Text(
                        '  Vegan: ${analysisData['Dietary Suitability']['Vegan']}'),
                    Text(
                        '  Vegetarian: ${analysisData['Dietary Suitability']['Vegetarian']}'),
                    Text(
                        '  Gluten-Free: ${analysisData['Dietary Suitability']['Gluten-Free']}'),
                    Text(
                        '  Keto: ${analysisData['Dietary Suitability']['Keto']}'),
                  ] else
                    Text('  ${analysisData['Dietary Suitability']}'),
                  Text('  Diabetic:'),
                  for (var diabetic in analysisData['Diabetic'])
                    Text('    - $diabetic'),
                  Text('Overall Analysis:'),
                  for (var analysis in analysisData['Overall Analysis'])
                    Text('  - $analysis'),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
