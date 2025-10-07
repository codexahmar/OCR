import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/arithmetic_provider.dart';

class FABActions extends StatelessWidget {
  const FABActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ArithmeticProvider>(
      builder: (context, provider, _) {
        if (provider.hasImage && !provider.isProcessing) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔁 Reset Button (Red Glow)
              GestureDetector(
                onTapDown: (_) => HapticFeedback.lightImpact(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5252).withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: FloatingActionButton.small(
                    heroTag: "reset",
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    onPressed: () => provider.reset(),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ⚡ Process Button (Gradient Glow)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF14B8A6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: const Color(0xFF14B8A6).withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: FloatingActionButton.extended(
                  heroTag: "process",
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  onPressed: () => provider.processImage(),
                  icon: const Icon(
                    Icons.calculate_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Process",
                    style: GoogleFonts.orbitron(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
