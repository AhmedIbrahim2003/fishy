part of 'recipe_cubit.dart';

abstract class RecipeState {}

abstract class LoadingState extends RecipeState {}

final class RecipeInitial extends RecipeState {}

class RecipeLoadingState extends LoadingState {}

final class RecipeSuccessState extends RecipeState {}
