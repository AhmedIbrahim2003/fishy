import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class FishClassifier {
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> loadModel() async {
    try {
      developer.log('Starting model loading process...');
      
      // Check if model file exists
      const modelPath = 'assets/model/fish_classification_model.tflite';
      developer.log('Loading model from path: $modelPath');
      
      // Load model
      developer.log('Creating TFLite interpreter...');
      _interpreter = await Interpreter.fromAsset(modelPath);
      developer.log('TFLite interpreter created successfully');
      
      // Get model details
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      developer.log('Model input shape: $inputShape');
      developer.log('Model output shape: $outputShape');
      
      // Load labels
      developer.log('Loading labels from metadata...');
      const labelsPath = 'assets/model/fish_classification_model_metadata.json';
      developer.log('Loading labels from path: $labelsPath');
      
      final labelsData = await rootBundle.loadString(labelsPath);
      developer.log('Labels data loaded: ${labelsData.length} bytes');
      
      final metadata = jsonDecode(labelsData);
      _labels = List<String>.from(metadata['classes']);
      developer.log('Labels loaded successfully: ${_labels!.length} classes');
      developer.log('Labels: ${_labels!.join(", ")}');
      
    } catch (e, stackTrace) {
      developer.log('Error loading model: $e');
      developer.log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> classifyImage(File imageFile) async {
    try {
      developer.log('Starting image classification process...');
      
      if (_interpreter == null || _labels == null) {
        developer.log('Model or labels not loaded, loading now...');
        await loadModel();
      }
      
      // Check if file exists and get its size
      developer.log('Reading image file: ${imageFile.path}');
      developer.log('Image file size: ${imageFile.lengthSync()} bytes');
      
      // Read and decode image
      developer.log('Decoding image...');
      final bytes = imageFile.readAsBytesSync();
      developer.log('Image bytes read: ${bytes.length} bytes');
      
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }
      developer.log('Image decoded successfully: ${image.width}x${image.height}');
      
      // Resize image
      developer.log('Resizing image to 224x224...');
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);
      developer.log('Image resized successfully');
      
      // Convert to float array and normalize
      developer.log('Converting image to tensor...');
      var input = List.filled(1 * 224 * 224 * 3, 0.0).reshape([1, 224, 224, 3]);
      
      developer.log('Normalizing pixel values...');
      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          final pixel = resizedImage.getPixel(x, y);
          input[0][y][x][0] = pixel.r / 255.0;
          input[0][y][x][1] = pixel.g / 255.0;
          input[0][y][x][2] = pixel.b / 255.0;
        }
      }
      developer.log('Image converted to tensor successfully');
      
      // Prepare output tensor
      developer.log('Preparing output tensor...');
      List<List<double>> output = List.generate(
        1, (_) => List<double>.filled(_labels!.length, 0.0)
      );
      
      // Run inference
      developer.log('Running inference...');
      _interpreter!.run(input, output);
      developer.log('Inference completed successfully');
      
      // Process results
      developer.log('Processing results...');
      List<double> probabilities = output[0];
      
      // Find the category with highest confidence
      int maxIndex = 0;
      double maxProb = probabilities[0];
      
      for (int i = 0; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          maxIndex = i;
        }
      }
      
      developer.log('Classification complete');
      developer.log('Top result: ${_labels![maxIndex]} (${maxProb.toStringAsFixed(4)})');
      
      // Log top 3 results
      var sortedIndices = List<int>.generate(probabilities.length, (i) => i)
        ..sort((a, b) => probabilities[b].compareTo(probabilities[a]));
      
      developer.log('Top 3 results:');
      for (int i = 0; i < 3 && i < sortedIndices.length; i++) {
        final idx = sortedIndices[i];
        developer.log('${_labels![idx]}: ${probabilities[idx].toStringAsFixed(4)}');
      }
      
      return {
        'class': _labels![maxIndex],
        'confidence': maxProb,
        'all_probabilities': probabilities
      };
    } catch (e, stackTrace) {
      developer.log('Error during classification: $e');
      developer.log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  void dispose() {
    developer.log('Disposing interpreter...');
    _interpreter?.close();
    developer.log('Interpreter disposed');
  }
}
