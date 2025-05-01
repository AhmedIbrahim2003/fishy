import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/data/fish_info.dart';
import '../../../../core/utils/fish_classifier.dart';
import '../../data/model/fish_model.dart';
import '../view/widgets/results_bottom_sheet.dart';
part 'fish_classifier_state.dart';

class FishClassifierCubit extends Cubit<FishClassifierState> {
  FishClassifierCubit() : super(FishClassifierInitial());
  static FishClassifierCubit get(context) =>
      BlocProvider.of(context, listen: false);

  CameraController? controller;

  Future<void> initCamera() async {
    try {
      emit(InitCameraLoading());
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      controller = CameraController(
        backCamera,
        ResolutionPreset.max,
        enableAudio: false,
      );

      await controller!.initialize();
      WakelockPlus.enable();
      emit(InitCameraSuccess());
    } catch (e) {
      emit(InitCameraError(errorMessage: 'Error initializing camera: $e'));
    }
  }

  Future<void> takePicture({required BuildContext context}) async {
    try {
      final XFile photo = await controller!.takePicture();

      await _processImage(context: context, imageFile: File(photo.path));
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> pickImage({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _processImage(context: context, imageFile: File(image.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _processImage(
      {required BuildContext context, required File imageFile}) async {
    try {
      emit(ProcessingImageLoading());
      final classifier = FishClassifier();
      await classifier.loadModel();
      final result = await classifier.classifyImage(imageFile);
      classifier.dispose();
      _showResultsBottomSheet(
          context: context, imageFile: imageFile, result: result);
      emit(ProcessingImageSuccess());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing image: $e'),
          backgroundColor: Colors.red,
        ),
      );
      emit(ProcessingImageError(
        errorMessage: 'Error processing image: $e',
      ));
    }
  }

  void _showResultsBottomSheet(
      {required BuildContext context,
      required File imageFile,
      required Map<String, dynamic> result}) {
    final confidence = (result['confidence'] * 100).toStringAsFixed(2);
    final fishClass = result['class'];
    final fish = _searchFishByName(fishClass);
    resultsBottomSheet(
        context: context,
        imageFile: imageFile,
        fish: fish!,
        confidence: double.parse(confidence));
  }

  Fish? _searchFishByName(String name) {
    final fishes = fishInfo.map((json) => Fish.fromJson(json)).toList();
    return fishes.firstWhere(
      (fish) => fish.name.toLowerCase() == name.toLowerCase(),
      orElse: () => Fish(
        name: '',
        poisonous: false,
        popularRegions: [],
      ),
    );
  }
}
