import '../models/arithmetic_result.dart';

class ArithmeticParser {
  /// Parses text containing arithmetic expressions and calculates results
  static ArithmeticResults parseAndCalculate(String text) {
    // Split the text into rows
    final lines = text.split('\n');
    
    // Process each line
    final List<ArithmeticResult> results = [];
    int grandTotal = 0;
    
    for (final line in lines) {
      // Skip empty lines
      if (line.trim().isEmpty) continue;
      
      // Check if the line contains arithmetic expressions
      final expressionPattern = RegExp(r'\d+\s*[+]\s*\d+');
      if (expressionPattern.hasMatch(line)) {
        // Calculate the result
        final result = _calculateExpression(line);
        
        // Add to results
        results.add(ArithmeticResult(
          expression: line.trim(),
          result: result,
        ));
        
        // Add to grand total
        grandTotal += result;
      }
    }
    
    return ArithmeticResults(
      rows: results,
      grandTotal: grandTotal,
    );
  }
  
  /// Calculates the result of an arithmetic expression
  static int _calculateExpression(String expression) {
    // Remove any non-numeric and non-plus characters
    final cleanedExpression = expression.replaceAll(RegExp(r'[^0-9+]'), '');
    
    // Split by + and convert to numbers
    final numbers = cleanedExpression.split('+').map((s) => int.tryParse(s) ?? 0).toList();
    
    // Sum the numbers
    return numbers.fold(0, (sum, number) => sum + number);
  }
  
  /// Formats the results according to the required output format
  static String formatResults(ArithmeticResults results) {
    final buffer = StringBuffer();
    
    // Format each row
    for (int i = 0; i < results.rows.length; i++) {
      final row = results.rows[i];
      buffer.writeln('Row ${i + 1}: ${row.expression} → Result = ${row.result}');
    }
    
    // Add grand total
    if (results.rows.isNotEmpty) {
      buffer.writeln('\nFinal Total = ${results.grandTotal}');
    } else {
      buffer.writeln('No arithmetic expressions found in the image.');
    }
    
    return buffer.toString();
  }
}