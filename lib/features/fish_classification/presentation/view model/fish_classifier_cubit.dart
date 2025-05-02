import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fishy/core/utils/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/data/fish_info.dart';
import '../../../../core/utils/database_helper.dart';
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

  Future<void> saveCatch(
      {required String fishName,
      required String photoPath,
      required double confidence}) async {
    try {
      emit(SavingCatchLoading());
      String savedPath = await savePhotoToAppDirectory(photoPath);
      final timestamp = DateTime.now().toIso8601String();
      final dbHelper = DatabaseHelper.instance;

      var id = await dbHelper.insertCatch(
        fishName: fishName,
        timestamp: timestamp,
        photoPath: savedPath,
        confidence: confidence,
      );
      await CacheHelper.putData(key: 'currentID', value: id);
      emit(SavingCatchSuccess());
    } catch (e) {
      debugPrint('Error saving catch: $e');
      emit(SavingCatchError(
        errorMessage: 'Error saving catch: $e',
      ));
    }
  }

  Future<String> savePhotoToAppDirectory(String tempPhotoPath) async {
    final tempPhoto = File(tempPhotoPath);

    if (!await tempPhoto.exists()) {
      throw Exception("Temp photo does not exist at path: $tempPhotoPath");
    }

    final appDir = await getApplicationDocumentsDirectory();

    final fileName =
        'catch_${DateTime.now().millisecondsSinceEpoch}${extension(tempPhotoPath)}';

    final savedPhotoPath = join(appDir.path, fileName);

    await tempPhoto.copy(savedPhotoPath);

    return savedPhotoPath;
  }

  Future<void> deleteCatch() async {
    try {
      emit(DeletingCatchLoading());

      final dbHelper = DatabaseHelper.instance;
      final id = CacheHelper.getData(key: 'currentID');

      // 1. Get the catch data before deleting
      final db = await dbHelper.database;
      final result = await db.query(
        'saved_catchs',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        final photoPath = result.first['photo_path'] as String?;

        // 2. Delete the image file if it exists
        if (photoPath != null) {
          final file = File(photoPath);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
      await dbHelper.deleteCatch(id);
      await CacheHelper.removeData(key: 'currentID');
      emit(DeletingCatchSuccess());
    } catch (e) {
      debugPrint('Error deleting catch: $e');
      emit(DeletingCatchError(
        errorMessage: 'Error deleting catch: $e',
      ));
    }
  }

  //check if the catch is saved or not
  bool isCatchSaved() {
    final id = CacheHelper.getData(key: 'currentID');
    return id != null;
  }

  @override
  Future<void> close() async {
    controller?.dispose();
    WakelockPlus.disable();
    await CacheHelper.removeData(key: 'currentID');
    return super.close();
  }
}
