import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalysisPage extends StatefulWidget {
  final String fdcId;

  const AnalysisPage({super.key, required this.fdcId});

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
      title: const Text('Food Analysis'),
    ),
    body: FutureBuilder<Map<String, dynamic>>(
      future: _analysisResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        } else if (snapshot.hasData) {
          final Map<String, dynamic> analysisData =
              parseAnalysisData(snapshot.data!['analysis']);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildAnalysisItems(analysisData),
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    ),
  );
}

List<Widget> _buildAnalysisItems(Map<String, dynamic> analysisData) {
  return [
    _buildAnalysisItem("Brand", analysisData['Brand']),
    _buildAnalysisItem("Ingredients", analysisData['Ingredients'].join(', ')),
    _buildAnalysisItem("Potential Allergens", analysisData['Potential Allergens']),
    _buildAnalysisItem("Positives", analysisData['Positive']),
    _buildAnalysisItem("Negatives", analysisData['Negatives']),
    _buildAnalysisItem("Considerations", analysisData['Considerations']),
    _buildAnalysisItem("Disclaimers", analysisData['Disclaimers']),
    _buildAnalysisItem("Vegan", analysisData['Vegan']),
    _buildAnalysisItem("Vegetarian", analysisData['Vegetarian']),
    _buildAnalysisItem("Gluten-Free", analysisData['Gluten-Free']),
    _buildAnalysisItem("Keto", analysisData['Keto']),
    _buildAnalysisItem("Diabetic", analysisData['Diabetic']),
    _buildAnalysisItem("Overall Analysis", "${analysisData['Paragraph1']}. ${analysisData['Paragraph2']}"),
  ].expand((widget) => [widget, const SizedBox(height: 15)]).toList(); // Add some spacing between items
}

Widget _buildAnalysisItem(String label, dynamic value) {
  String displayValue = value.toString();
  if (value is List) {
    displayValue = value.join(', ');
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "$label: $displayValue",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      const SizedBox(height: 5), // Add some vertical spacing between label and value
    ],
  );
}

}
