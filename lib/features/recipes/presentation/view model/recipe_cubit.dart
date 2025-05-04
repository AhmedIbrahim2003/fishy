import 'package:fishy/features/recipes/data/fish_all_recipes_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/json/recipes.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit({required String fishName}) : super(RecipeInitial()){
    _getRecipesByFishName(fishName);
  }
  static RecipeCubit get(context) => BlocProvider.of(context, listen: false);
  FishAllRecipes allRecipes = FishAllRecipes();

  void _getRecipesByFishName(String fishName) {
    final recipesList = recipesJson.firstWhere(
      (recipe) =>
          recipe['name'].toString().toLowerCase() == fishName.toLowerCase(),
    );

    allRecipes = FishAllRecipes.fromJson(recipesList);
  }
}
