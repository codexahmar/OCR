import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  late final String _apiKey;

  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal() {
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (_apiKey.isEmpty) {
      print('WARNING: GEMINI_API_KEY is empty or not found in .env file');
      throw Exception('Gemini API key not found in .env file');
    } else {
      print('API key loaded successfully (length: ${_apiKey.length})');
    }
  }

  Future<String> extractTextFromImage(File imageFile) async {
    try {
      print('Starting image processing');
      print('Image file path: ${imageFile.path}');
      print('Image file exists: ${await imageFile.exists()}');
      print('Image file size: ${await imageFile.length()} bytes');

      // Read the image file as bytes
      print('Reading image file as bytes...');
      final bytes = await imageFile.readAsBytes();
      print('Successfully read ${bytes.length} bytes from image');

      // Detect MIME type based on file extension
      String mimeType = 'image/jpeg'; // Default
      final extension = imageFile.path.split('.').last.toLowerCase();
      print('Image file extension: $extension');

      if (extension == 'png') {
        mimeType = 'image/png';
      } else if (extension == 'gif') {
        mimeType = 'image/gif';
      } else if (extension == 'webp') {
        mimeType = 'image/webp';
      } else if (extension == 'heic' || extension == 'heif') {
        print('Warning: HEIC/HEIF format may not be supported by the API');
        mimeType = 'image/heic';
      }
      print('Using MIME type: $mimeType');

      // Encode to base64
      print('Encoding image to base64...');
      final base64Image = base64Encode(bytes);
      print(
        'Successfully encoded image to base64 (length: ${base64Image.length})',
      );

      // Prepare the request body
      print('Preparing request body...');
      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Extract all text from this image, focusing on arithmetic calculations. Return only the extracted text, no additional commentary.",
              },
              {
                "inline_data": {"mime_type": mimeType, "data": base64Image},
              },
            ],
          },
        ],
        "generationConfig": {
          "temperature": 0.1,
          "topK": 32,
          "topP": 1,
          "maxOutputTokens": 4096,
        },
      });
      print('Request body prepared (length: ${body.length})');

      print('Sending request to Gemini API');
      // Make the API request
      final apiUrl =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey';
      print('API URL: $apiUrl');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Response received with status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Successful response, parsing JSON');
        try {
          final jsonResponse = jsonDecode(response.body);
          print(
            'JSON decoded successfully: ${jsonResponse.toString().substring(0, min(100, jsonResponse.toString().length))}...',
          );

          if (jsonResponse['candidates'] == null ||
              jsonResponse['candidates'].isEmpty) {
            print('Error: No candidates in response');
            throw Exception('No candidates in API response');
          }

          if (jsonResponse['candidates'][0]['content'] == null) {
            print('Error: No content in first candidate');
            throw Exception('No content in API response candidate');
          }

          if (jsonResponse['candidates'][0]['content']['parts'] == null ||
              jsonResponse['candidates'][0]['content']['parts'].isEmpty) {
            print('Error: No parts in content');
            throw Exception('No parts in API response content');
          }

          final text =
              jsonResponse['candidates'][0]['content']['parts'][0]['text'];
          print('Extracted text: $text');
          return text;
        } catch (e) {
          print('JSON parsing error: $e');
          print('Response body: ${response.body}');
          throw Exception('Failed to parse API response: $e');
        }
      } else {
        print('API error: ${response.statusCode} ${response.body}');
        throw Exception(
          'Failed to extract text: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e, stackTrace) {
      print('ERROR DETAILS:');
      print('Error extracting text from image: $e');
      print('Stack trace: $stackTrace');

      if (e is FileSystemException) {
        print('File system error: ${e.message}');
        print('File path: ${e.path}');
        print('OS error: ${e.osError}');
      } else if (e is HttpException) {
        print('HTTP error: ${e.message}');
        print('URI: ${e.uri}');
      } else if (e is FormatException) {
        print('Format error: ${e.message}');
        print('Source: ${e.source}');
      }

      throw Exception('Error extracting text from image: $e');
    }
  }
}
