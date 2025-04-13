import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

import 'fish_classifier.dart';

class ProcessScreen extends StatefulWidget {
  final File imageFile;

  const ProcessScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  bool _isProcessing = true;
  String? _processedImagePath;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  Future<void> _processImage() async {
    try {
      // Simulate image processing
      var analysis = await FishClassifier().classifyImage(widget.imageFile);
      log(analysis.toString());
      setState(() {
        _processedImagePath = widget.imageFile.path;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error processing image: $e';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing Image'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Processing your image...'),
                ],
              )
            : _errorMessage != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_processedImagePath != null)
                        Container(
                          height: 300,
                          width: double.infinity,
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.file(
                            File(_processedImagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
