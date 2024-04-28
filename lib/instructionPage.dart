import 'package:flutter/material.dart';

class InstructionPage extends StatefulWidget{
  const InstructionPage({super.key});

  @override
  _InstructionPageState createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'How to Use the App:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 20), // Add space between title and list
            _buildInstructionListItem('Start by navigating to the search page and typing the name of a food item in the search bar.'),
            _buildInstructionListItem('Press Enter or tap the search icon to initiate the search.'),
            _buildInstructionListItem('Tap on a food item to view its product description.'),
            _buildInstructionListItem('After accessing the food item\'s details, further analyze to find additional information.'),
            _buildInstructionListItem('Look for certifications or labels indicating organic, non-GMO, or other attributes of the food item.'),
            // Add more instructions as needed
            // Add more instructions as needed
          ],
        ),
      ),
    );
  }
}

Widget _buildInstructionListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 32,
            child: Text(
              '•',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8), // Add space between bullet and text
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Roboto', // Change the font family
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
