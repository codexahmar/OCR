import '../models/arithmetic_result.dart';

class ArithmeticParser {
  static ArithmeticResults parseAndCalculate(String text) {
    final lines = text.split(RegExp(r'\r?\n'));
    final List<ArithmeticResult> results = [];
    double grandTotal = 0.0;
    for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty) continue;

      final cells = line.split('|');

      double rowTotal = 0.0;
      final cellResults = <String, double>{};

      for (final cell in cells) {
        final expr = _extractExpression(cell);
        if (expr.isEmpty) continue;

        final value = _safeEvaluate(expr);
        cellResults[expr] = value;
        rowTotal += value;
      }

      results.add(ArithmeticResult(expression: line, result: rowTotal));
      grandTotal += rowTotal;
    }

    return ArithmeticResults(rows: results, grandTotal: grandTotal);
  }

  static String _extractExpression(String input) {
    if (input.trim().isEmpty) return '';

    var s = input
        .replaceAll('×', '*')
        .replaceAll('X', '*')
        .replaceAll('x', '*');
    s = s.replaceAll('÷', '/');

    s = s.replaceAll(RegExp(r'[^0-9\.\+\-\*\/\(\)]'), '');

    if (!RegExp(r'\d').hasMatch(s)) return '';

    if (s.startsWith('-')) s = '0$s';
    s = s.replaceAll('(-', '(0-');

    // Very small final validation
    if (s.isEmpty) return '';
    return s;
  }

  static double _safeEvaluate(String expr) {
    try {
      return _evaluateExpression(expr);
    } catch (e) {
      return 0.0;
    }
  }

  static double _evaluateExpression(String expr) {
    final s = expr.replaceAll(' ', '');

    final tokenRegex = RegExp(r'\d+\.\d+|\d+|[+\-*/()]');
    final matches = tokenRegex.allMatches(s);
    final tokens = matches.map((m) => m.group(0)!).toList();

    final output = <String>[];
    final ops = <String>[];

    int prec(String op) {
      if (op == '+' || op == '-') return 1;
      if (op == '*' || op == '/') return 2;
      return 0;
    }

    bool isOp(String t) => t == '+' || t == '-' || t == '*' || t == '/';

    for (final token in tokens) {
      if (RegExp(r'^\d+(\.\d+)?$').hasMatch(token)) {
        output.add(token);
      } else if (isOp(token)) {
        while (ops.isNotEmpty &&
            isOp(ops.last) &&
            prec(ops.last) >= prec(token)) {
          output.add(ops.removeLast());
        }
        ops.add(token);
      } else if (token == '(') {
        ops.add(token);
      } else if (token == ')') {
        while (ops.isNotEmpty && ops.last != '(') {
          output.add(ops.removeLast());
        }
        if (ops.isNotEmpty && ops.last == '(') {
          ops.removeLast();
        } else {
          throw Exception('Mismatched parentheses');
        }
      } else {
        throw Exception('Unknown token: $token');
      }
    }

    while (ops.isNotEmpty) {
      final top = ops.removeLast();
      if (top == '(' || top == ')') throw Exception('Mismatched parentheses');
      output.add(top);
    }

    // Evaluate RPN
    final stack = <double>[];
    for (final token in output) {
      if (RegExp(r'^\d+(\.\d+)?$').hasMatch(token)) {
        stack.add(double.parse(token));
      } else if (isOp(token)) {
        if (stack.length < 2) throw Exception('Invalid expression');
        final b = stack.removeLast();
        final a = stack.removeLast();
        double r;
        switch (token) {
          case '+':
            r = a + b;
            break;
          case '-':
            r = a - b;
            break;
          case '*':
            r = a * b;
            break;
          case '/':
            r = a / b;
            break;
          default:
            throw Exception('Unsupported operator: $token');
        }
        stack.add(r);
      } else {
        throw Exception('Unknown RPN token: $token');
      }
    }

    if (stack.length != 1) throw Exception('Invalid expression evaluation');
    return stack.single;
  }

  static String formatResults(ArithmeticResults results) {
    final buffer = StringBuffer();

    if (results.rows.isEmpty) {
      buffer.writeln('No arithmetic expressions found in the image.');
      return buffer.toString();
    }

    for (int i = 0; i < results.rows.length; i++) {
      final row = results.rows[i];
      buffer.writeln(
        'Row ${i + 1}: ${row.expression} → Result = ${_formatNumber(row.result)}',
      );
    }

    buffer.writeln('');
    buffer.writeln('Final Total = ${_formatNumber(results.grandTotal)}');

    return buffer.toString();
  }

  static String _formatNumber(double v) {
    if (v == v.roundToDouble()) {
      return v.toInt().toString();
    } else {
      return v.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0+$'), '');
    }
  }
}
