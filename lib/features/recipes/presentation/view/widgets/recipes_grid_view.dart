import 'package:fishy/features/recipes/presentation/view%20model/recipe_cubit.dart';
import 'package:fishy/features/recipes/presentation/view/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RecipesGridView extends StatelessWidget {
  const RecipesGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          mainAxisExtent: 23.h,
        ),
        itemCount: RecipeCubit.get(context).allRecipes.recipe?.length ?? 0,
        itemBuilder: (context, index) {
          return RecipeCard(
              recipe: RecipeCubit.get(context).allRecipes.recipe![index]);
        });
  }
}
