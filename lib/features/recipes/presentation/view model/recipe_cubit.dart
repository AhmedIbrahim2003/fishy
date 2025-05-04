import 'package:fishy/features/recipes/data/fish_all_recipes_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/json/recipes.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit({String fishName = '', bool isEveryRecipyMenu = false})
      : super(RecipeInitial()) {
    isEveryRecipyMenu ? _getEveryRecipes() : _getRecipesByFishName(fishName);
  }
  static RecipeCubit get(context) => BlocProvider.of(context, listen: false);
  FishAllRecipes allRecipes = FishAllRecipes();
  List<FishAllRecipes> everyRecipes = [];

  void _getRecipesByFishName(String fishName) {
    emit(RecipeLoadingState());
    final recipesList = recipesJson.firstWhere(
      (recipe) =>
          recipe['name'].toString().toLowerCase() == fishName.toLowerCase(),
    );

    allRecipes = FishAllRecipes.fromJson(recipesList);
    emit(RecipeSuccessState());
  }

  void _getEveryRecipes() {
    emit(RecipeLoadingState());
    everyRecipes = recipesJson.map((recipe) {
      return FishAllRecipes.fromJson(recipe);
    }).toList();
    emit(RecipeSuccessState());
  }
}
