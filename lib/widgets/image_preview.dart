import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File imageFile;

  const ImagePreviewScreen({Key? key, required this.imageFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Hero(
            tag: "uploaded-image-preview",
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              panEnabled: true,
              minScale: 0.8,
              maxScale: 4.0,
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
