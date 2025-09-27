import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsDisplay extends StatelessWidget {
  final String results;

  const ResultsDisplay({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxHeight: 350, // Limit max height to prevent overflow
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Results',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _buildResultsText(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsText() {
    final lines = results.split('\n');
    final List<Widget> resultWidgets = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.startsWith('Row')) {
        final parts = line.split('→');
        if (parts.length == 2) {
          resultWidgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      parts[0].trim(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    '→',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    parts[1].trim(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          resultWidgets.add(_buildSimpleLine(line));
        }
      } else if (line.contains('Final Total')) {
        resultWidgets.add(const Divider(color: Colors.black26));
        resultWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              line,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
      } else if (line.isNotEmpty) {
        resultWidgets.add(_buildSimpleLine(line));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: resultWidgets,
    );
  }

  Widget _buildSimpleLine(String line) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        line,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}
