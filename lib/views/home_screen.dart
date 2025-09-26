import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../controllers/arithmetic_provider.dart';
import '../widgets/results_display.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Expression Scanner",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ),
      body: Consumer<ArithmeticProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Image section
                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: () => _getImage(context, ImageSource.gallery),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: -5,
                            offset: const Offset(0, 5),
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: provider.hasImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                provider.selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 60,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Tap to upload image",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildRoundedButton(
                        context,
                        label: "Camera",
                        icon: Icons.camera_alt,
                        onPressed: () => _getImage(context, ImageSource.camera),
                        isPrimary: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildRoundedButton(
                        context,
                        label: "Gallery",
                        icon: Icons.photo_library,
                        onPressed: () =>
                            _getImage(context, ImageSource.gallery),
                        isPrimary: false,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Results
                Expanded(
                  flex: 5,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _buildResultsSection(provider),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildRoundedButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isPrimary ? colorScheme.primary : Colors.white,
        foregroundColor: isPrimary ? Colors.white : colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildResultsSection(ArithmeticProvider provider) {
    if (provider.isProcessing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingCircle(color: Colors.blue, size: 50),
            const SizedBox(height: 16),
            Text(
              "Analyzing your image...",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
    } else if (provider.hasError) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Text(
          provider.errorMessage,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.red.shade700),
        ),
      );
    } else if (provider.hasResults) {
      return ResultsDisplay(results: provider.formattedResults);
    }

    return Center(
      child: Text(
        "Your results will appear here",
        style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey.shade500),
      ),
    );
  }

  Widget? _buildFAB(BuildContext context) {
    return Consumer<ArithmeticProvider>(
      builder: (context, provider, _) {
        if (provider.hasImage && !provider.isProcessing) {
          return FloatingActionButton.extended(
            onPressed: () {
              provider.processImage();
            },
            icon: const Icon(Icons.calculate, color: Colors.white),
            label: Text(
              "Process",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _getImage(BuildContext context, ImageSource source) async {
    final provider = Provider.of<ArithmeticProvider>(context, listen: false);
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        provider.setImage(File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error picking image: $e")));
    }
  }
}
