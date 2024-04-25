import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'api_keys.dart';

class AnalysisPage extends StatefulWidget {
  final String fdcId;

  AnalysisPage({Key? key, required this.fdcId}) : super(key: key);

  @override
  _AnalysisPageState createState() => _AnalysisPageState(fdcId: fdcId);
}

class _AnalysisPageState extends State<AnalysisPage> {
  late Future<String> _analysisResult;
  final String fdcId;

  _AnalysisPageState({required this.fdcId});

  @override
  void initState() {
    super.initState();
    _analysisResult = _fetchAnalysis();
  }

  Future<String> _fetchAnalysis() async {
    final String foodDetailsJson = await _fetchFoodDetails();
    final String prompt = generatePrompt(foodDetailsJson);

    final apiKey =
        geminiApiKey; // Make sure your API key is correctly configured
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent?key=$apiKey');

    // Prepare the JSON request body with the correct configuration
    final requestBody = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "generationConfig": {
        "response_mime_type":
            "application/json", // Requesting JSON format response
      }
    });

    // Send the POST request to the API
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json'
      }, // Set headers to indicate JSON content type
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      print('Response from model: ${response.body}');
      return _formatAnalysis(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to generate content with status code: ${response.statusCode}');
    }
  }


  Future<String> _fetchFoodDetails() async {
    final url = Uri.parse(
        'https://get-food-details-mfckn4ttpa-uc.a.run.app/?fdcId=$fdcId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
            'Failed to load food details (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching food details: $e');
      throw Exception('Failed to fetch food details');
    }
  }

  String _formatAnalysis(String jsonText) {
    try {
      final Map<String, dynamic> responseData = jsonDecode(jsonText);
      // Assuming responseData contains a key 'candidates' which is a list
      List candidates = responseData['candidates'];

      // Since you expect only one candidate usually, we will take the first one
      if (candidates.isNotEmpty) {
        Map<String, dynamic> firstCandidate =
            candidates.first['content']['parts'].first;
        // Parse the JSON formatted string inside the 'text' key
        String jsonContent = firstCandidate['text'];
        // Remove the extra square brackets and newlines from the string
        jsonContent =
            jsonContent.trim().substring(1, jsonContent.length - 2).trim();
        // Decode the JSON string inside
        Map<String, dynamic> actualData = jsonDecode(jsonContent);

        // Format the extracted data into a readable format or process it as needed
        StringBuffer formatted = StringBuffer();
        formatted.writeln('Brand: ${actualData["Brand"]}');
        formatted.writeln('Ingredients: ${actualData["Ingredients"]}');
        formatted.writeln(
            'Potential Allergens: ${actualData["Potential Allergens"]}');
        formatted.writeln('Health Evaluation:');
        formatted.writeln(
            '  Positives: ${actualData["Health Evaluation"]["Positives"].join(", ")}');
        formatted.writeln(
            '  Negatives: ${actualData["Health Evaluation"]["Negatives"].join(", ")}');
        formatted.writeln(
            '  Considerations: ${actualData["Health Evaluation"]["Considerations"].join(", ")}');
        formatted.writeln('Disclaimers: ${actualData["Disclaimers"]}');
        formatted.writeln('Dietary Suitability:');
        formatted
            .writeln('  Vegan: ${actualData["Dietary Suitability"]["Vegan"]}');
        formatted.writeln(
            '  Vegetarian: ${actualData["Dietary Suitability"]["Vegetarian"]}');
        formatted.writeln(
            '  Gluten-Free: ${actualData["Dietary Suitability"]["Gluten-Free"]}');
        formatted
            .writeln('  Keto: ${actualData["Dietary Suitability"]["Keto"]}');
        formatted.writeln(
            '  Diabetic: ${actualData["Dietary Suitability"]["Diabetic"]}');
        formatted
            .writeln('Overall Analysis: ${actualData["Overall Analysis"]}');

        return formatted.toString();
      }
      return "No valid data found in response.";
    } catch (e) {
      print('Error formatting analysis: $e');
      return 'Failed to format analysis data: $e';
    }
  }



  String generatePrompt(String foodDetails) {
    return """
    You are acting as a health advisor analyzing a food product. Please analyze all the provided information and return a detailed analysis in a JSON format with the following keys:
    * **Brand**: [Brand Name]
    * **Ingredients**: [Ingredients List]
    * **Potential Allergens**: [List Potential Allergens, or 'None' if not apparent from ingredients]
    * **Health Evaluation**: 
        * **Positives**: [Highlight potential benefits.]
        * **Negatives**: [Highlight potential drawbacks or concerns.]
        * **Considerations**: [Additional factors to keep in mind.] 
    * **Disclaimers**: [Include any necessary disclaimers regarding individual health or dietary restrictions.]
    * **Dietary Suitability**: 
        * **Vegan**: [Yes/No]
        * **Vegetarian**: [Yes/No]
        * **Gluten-Free**: [Yes/No - Or indicate if it cannot be determined from the provided ingredients]
        * **Keto**: [Yes/No]
        * **Diabetic**: [Suitable, Suitable with moderation, Not suitable - Explain briefly]
    * **Overall Analysis**: Provide a concise two-paragraph summary. In the first paragraph, outline the product's suitability for weight management and sugar control, alongside any notable benefits. In the second paragraph, address potential health concerns, long-term effects of ingredients, and suggest healthier alternatives where relevant.  
    Please analyze the following product:
    $foodDetails 
    """;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Page'),
      ),
      body: FutureBuilder<String>(
        future: _analysisResult,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final formattedAnalysis = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Text(
                formattedAnalysis,
                style: TextStyle(fontSize: 16.0),
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
