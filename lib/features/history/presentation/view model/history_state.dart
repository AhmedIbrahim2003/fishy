part of 'history_cubit.dart';

abstract class HistoryState {}

abstract class LoadingState extends HistoryState {}

final class HistoryInitial extends HistoryState {}

final class GetGroupedCatchesLoading extends LoadingState {}

final class GetGroupedCatchesSuccess extends HistoryState {}

final class GetGroupedCatchesError extends HistoryState {
  final String errorMessage;
  GetGroupedCatchesError({required this.errorMessage});
}

final class DeletingCatchLoading extends LoadingState {}

final class DeletingCatchSuccess extends HistoryState {}

final class DeletingCatchError extends HistoryState {
  final String errorMessage;
  DeletingCatchError({required this.errorMessage});
}
