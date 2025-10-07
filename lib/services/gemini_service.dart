import 'dart:convert';
import 'dart:io';
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
      final bytes = await imageFile.readAsBytes();
      String mimeType = 'image/jpeg';
      final extension = imageFile.path.split('.').last.toLowerCase();
      if (extension == 'png') mimeType = 'image/png';
      if (extension == 'gif') mimeType = 'image/gif';
      if (extension == 'webp') mimeType = 'image/webp';

      final base64Image = base64Encode(bytes);

      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": """
You are an OCR engine. Extract all visible text from the attached image.
The image contains numbers and arithmetic expressions, arranged in rows
and sometimes in columns (like tables).

⚡ Rules:
1. Return ONLY the raw text — no explanations, no extra symbols.
2. Preserve row order (one line per row).
3. If columns are visible, separate them using the '|' character.
   Example:  1 + 2 + 3 | 4 + 5
4. Keep arithmetic symbols exactly as they appear (+, -, *, /, ×, ÷, %, ^, parentheses).
5. Do not solve or simplify expressions, just transcribe them.
6. If any part is unclear, output it as-is (don’t guess or skip).
""",
              },
              {
                "inline_data": {"mime_type": mimeType, "data": base64Image},
              },
            ],
          },
        ],
        "generationConfig": {
          "temperature": 0.0,
          "topK": 1,
          "topP": 1,
          "maxOutputTokens": 2048,
        },
      });

      final apiUrl =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['candidates'] == null ||
            jsonResponse['candidates'].isEmpty ||
            jsonResponse['candidates'][0]['content'] == null ||
            jsonResponse['candidates'][0]['content']['parts'] == null ||
            jsonResponse['candidates'][0]['content']['parts'].isEmpty) {
          throw Exception('No usable content in API response');
        }
        final text =
            jsonResponse['candidates'][0]['content']['parts'][0]['text']
                as String;
        return text;
      } else {
        throw Exception(
          'Gemini API error: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e, st) {
      print('Error extracting text: $e\n$st');
      rethrow;
    }
  }
}
