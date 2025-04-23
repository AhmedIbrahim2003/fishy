part of 'fish_classifier_cubit.dart';

abstract class FishClassifierState {}

abstract class LoadingState extends FishClassifierState {}

final class FishClassifierInitial extends FishClassifierState {}

final class InitCameraLoading extends LoadingState {}

final class InitCameraSuccess extends FishClassifierState {}

final class InitCameraError extends FishClassifierState {
  final String errorMessage;
  InitCameraError({required this.errorMessage});
}

final class ProcessingImageLoading extends LoadingState {}

final class ProcessingImageSuccess extends FishClassifierState {}

final class ProcessingImageError extends FishClassifierState {
  final String errorMessage;
  ProcessingImageError({required this.errorMessage});
}
