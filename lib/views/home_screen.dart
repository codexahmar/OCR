import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/actionButtons.dart';
import 'package:flutter_application_1/widgets/fab.dart';
import 'package:flutter_application_1/widgets/image_preview.dart';
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(22),
              bottomRight: Radius.circular(22),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt_rounded,
              color: Colors.white.withOpacity(0.95),
              size: 26,
            ),
            const SizedBox(width: 8),
            Text(
              "SnapSolve",
              style: GoogleFonts.orbitron(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.tealAccent.withOpacity(0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Consumer<ArithmeticProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        onTap: () => _getImage(context, ImageSource.gallery),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: const Color(0xFF14B8A6).withOpacity(0.3),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 25,
                                spreadRadius: 2,
                                color: const Color(
                                  0xFF14B8A6,
                                ).withOpacity(0.25),
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: provider.hasImage
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ImagePreviewScreen(
                                          imageFile: provider.selectedImage!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: "uploaded-image-preview",
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.file(
                                        provider.selectedImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF14B8A6),
                                              Color(0xFF6366F1),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF14B8A6,
                                              ).withOpacity(0.5),
                                              blurRadius: 30,
                                              spreadRadius: 3,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(22),
                                        child: const Icon(
                                          Icons.add_a_photo_rounded,
                                          size: 54,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "Tap to upload image",
                                        style: GoogleFonts.orbitron(
                                          color: Colors.white70,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "AI will read & solve the expression",
                                        style: GoogleFonts.orbitron(
                                          color: Colors.white38,
                                          fontSize: 12,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: ActionButton(
                            label: "Camera",
                            icon: Icons.camera_alt_rounded,
                            onPressed: () =>
                                _getImage(context, ImageSource.camera),
                            isPrimary: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ActionButton(
                            label: "Gallery",
                            icon: Icons.photo_library_rounded,
                            onPressed: () =>
                                _getImage(context, ImageSource.gallery),
                            isPrimary: false,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Expanded(
                      flex: 5,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: _buildResultsSection(provider),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FABActions(),
    );
  }

  Widget _buildResultsSection(ArithmeticProvider provider) {
    if (provider.isProcessing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitThreeBounce(color: Colors.tealAccent, size: 40),
            const SizedBox(height: 16),
            Text(
              "Analyzing your image...",
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );
    } else if (provider.hasError) {
      return _buildError(provider.errorMessage);
    } else if (provider.hasResults) {
      return ResultsDisplay(results: provider.formattedResults);
    }

    return Center(
      child: Text(
        "Results will appear here",
        style: GoogleFonts.outfit(fontSize: 20, color: Colors.white54),
      ),
    );
  }

  Widget _buildError(String msg) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Text(
        msg,
        style: GoogleFonts.outfit(
          fontSize: 14,
          color: Colors.redAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
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
