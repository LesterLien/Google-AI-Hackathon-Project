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
        'https://generate-analysis-mfckn4ttpa-uc.a.run.app?fdcId=$fdcId');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load analysis: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load analysis: $e');
    }
  }

  Map<String, dynamic> parseAnalysisData(String rawData) {
    Map<String, dynamic> parsedData = {};

    List<String> pairs = rawData.split('~');
    for (String pair in pairs) {
      int index = pair.indexOf(':');
      if (index != -1) {
        String key = pair.substring(0, index).trim();
        String value = pair.substring(index + 1).trim();

        if (value.contains(';')) {
          List<String> listValues =
              value.split(';').map((e) => e.trim()).toList();
          parsedData[key] = listValues;
        } else {
          parsedData[key] = value;
        }
      }
    }

    return parsedData;
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
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            // Use the parseAnalysisData function to convert the string to a Map
            final Map<String, dynamic> analysisData =
                parseAnalysisData(snapshot.data!['analysis']);

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Brand: ${analysisData['Brand']}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 10),
                  Text("Ingredients: ${analysisData['Ingredients'].join(', ')}"),
                  SizedBox(height: 10),
                  Text("Potential Allergens: ${analysisData['Potential Allergens']}"),
                  SizedBox(height: 10),
                  Text("Positives: ${analysisData['Positive']}"),
                  SizedBox(height: 10),
                  Text("Negatives: ${analysisData['Negatives']}"),
                  SizedBox(height: 10),
                  Text("Considerations: ${analysisData['Considerations']}"),
                  SizedBox(height: 10),
                  Text("Disclaimers: ${analysisData['Disclaimers']}"),
                  SizedBox(height: 10),
                  Text("Vegan: ${analysisData['Vegan']}"),
                  SizedBox(height: 10),
                  Text("Vegetarian: ${analysisData['Vegetarian']}"),
                  SizedBox(height: 10),
                  Text("Gluten-Free: ${analysisData['Gluten-Free']}"),
                  SizedBox(height: 10),
                  Text("Keto: ${analysisData['Keto']}"),
                  SizedBox(height: 10),
                  Text("Considerations: ${analysisData['Considerations']}"),
                  SizedBox(height: 10),
                  Text("Diabetic: ${analysisData['Diabetic']}"),
                  SizedBox(height: 10),
                  Text("Overall Analysis: ${analysisData['Paragraph1']}. " "${analysisData['Paragraph2']}"),
                  SizedBox(height: 10),
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
