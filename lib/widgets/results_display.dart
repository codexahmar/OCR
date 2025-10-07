import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsDisplay extends StatelessWidget {
  final String results;
  const ResultsDisplay({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lines = results.split('\n');

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1E293B).withOpacity(0.75),
                const Color(0xFF0F172A).withOpacity(0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 1.3,
              color: const Color(0xFF6366F1).withOpacity(0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.25),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: const Color(0xFF14B8A6).withOpacity(0.15),
                blurRadius: 40,
                spreadRadius: -5,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: lines.length,
            itemBuilder: (context, index) {
              final line = lines[index];
              return AnimatedOpacity(
                duration: Duration(milliseconds: 400 + (index * 120)),
                opacity: 1,
                child: _buildLine(line),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLine(String line) {
    if (line.startsWith("Row")) {
      final parts = line.split('→');
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF6366F1).withOpacity(0.15),
              const Color(0xFF14B8A6).withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF6366F1).withOpacity(0.25),
            width: 1,
          ),
        ),
        child: ListTile(
          title: Text(
            parts[0].trim(),
            style: GoogleFonts.outfit(fontSize: 14.5, color: Colors.white70),
          ),
          trailing: Text(
            parts.length > 1 ? parts[1].trim() : "",
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF14B8A6),
              letterSpacing: 1.2,
            ),
          ),
        ),
      );
    } else if (line.contains("Total")) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            line,
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF10B981),
              shadows: [
                Shadow(
                  color: const Color(0xFF10B981).withOpacity(0.4),
                  blurRadius: 16,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return line.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              line,
              style: GoogleFonts.outfit(fontSize: 14.5, color: Colors.white60),
            ),
          )
        : const SizedBox.shrink();
  }
}
