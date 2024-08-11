import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'dart:typed_data';

class GeminiService {
  final GenerativeModel model;

  GeminiService(String apiKey)
      : model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

  Future<List<Map<String,dynamic>>>extractTaskFromImage(Uint8List imageBytes) async {
    final prompt = 'Extract all task and time from this image. Return as list of object with "task" and "time" keys in JSON format.';
    final content = [
      Content.text(prompt),
      Content.data('image/jpeg', imageBytes),
    ];

    try {
      final response = await model.generateContent(content);
      final textResponse = response.text;
      print('textResponse: $textResponse \n \n Response: $response');

      if (textResponse != null) {
        // Remove any markdown formatting and extract the JSON
        // final jsonString = extractJsonFromString(textResponse);
        final ListOfObjects = textResponse.replaceAll(RegExp(r'```json\n|\n```'), '');

    final List<dynamic> decodedList =  json.decode(ListOfObjects);

    return List<Map<String,dynamic>>.from(decodedList);

      } else {
        print('Error: Empty response from the model');
        return  [{"task": "", "time": ""}];
      }
    } catch (e) {
      print('Error generating content or parsing JSON: $e');
      return  [{"task": "", "time": ""}];


    }
  }

  String extractJsonFromString(String input) {
    // Remove markdown code block if present
    final withoutMarkdown = input.replaceAll(RegExp(r'```json\n|\n```'), '');

    // Find the first { and last } to extract the JSON object
    final startIndex = withoutMarkdown.indexOf('{');
    final endIndex = withoutMarkdown.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return withoutMarkdown.substring(startIndex, endIndex + 1);
    } else {
      throw FormatException('No valid JSON object found in the response');
    }
  }
}