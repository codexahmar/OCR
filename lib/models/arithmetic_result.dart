class ArithmeticResult {
  final String expression;
  final double result;

  ArithmeticResult({required this.expression, required this.result});
}

class ArithmeticResults {
  final List<ArithmeticResult> rows;
  final double grandTotal;

  ArithmeticResults({required this.rows, required this.grandTotal});

  factory ArithmeticResults.empty() {
    return ArithmeticResults(rows: [], grandTotal: 0.0);
  }
}
