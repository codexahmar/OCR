import 'dart:io';
import 'package:flutter/material.dart';
import '../models/arithmetic_result.dart';
import '../services/gemini_service.dart';
import '../utils/arithmetic_parser.dart';

enum ProcessingStatus { idle, loading, success, error }

class ArithmeticProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();

  File? _selectedImage;
  ProcessingStatus _status = ProcessingStatus.idle;
  String _errorMessage = '';
  ArithmeticResults _results = ArithmeticResults.empty();
  String _formattedResults = '';

  // Getters
  File? get selectedImage => _selectedImage;
  ProcessingStatus get status => _status;
  String get errorMessage => _errorMessage;
  ArithmeticResults get results => _results;
  String get formattedResults => _formattedResults;
  bool get hasImage => _selectedImage != null;
  bool get isProcessing => _status == ProcessingStatus.loading;
  bool get hasResults => _formattedResults.isNotEmpty;
  bool get hasError => _status == ProcessingStatus.error;

  // Set selected image
  void setImage(File? image) {
    _selectedImage = image;
    // Reset results when a new image is selected
    if (image != null) {
      _status = ProcessingStatus.idle;
      _errorMessage = '';
      _results = ArithmeticResults.empty();
      _formattedResults = '';
    }
    notifyListeners();
  }

  // Process the selected image
  Future<void> processImage() async {
    if (_selectedImage == null) return;

    try {
      _status = ProcessingStatus.loading;
      _errorMessage = '';
      notifyListeners();

      // Extract text from image using Gemini API
      final extractedText = await _geminiService.extractTextFromImage(
        _selectedImage!,
      );

      // Parse and calculate arithmetic expressions
      _results = ArithmeticParser.parseAndCalculate(extractedText);

      // Format results
      _formattedResults = ArithmeticParser.formatResults(_results);

      _status = ProcessingStatus.success;
    } catch (e) {
      _status = ProcessingStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Reset everything
  void reset() {
    _selectedImage = null;
    _status = ProcessingStatus.idle;
    _errorMessage = '';
    _results = ArithmeticResults.empty();
    _formattedResults = '';
    notifyListeners();
  }
}
