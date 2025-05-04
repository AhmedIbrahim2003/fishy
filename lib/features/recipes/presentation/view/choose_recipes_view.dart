import 'package:fishy/features/recipes/presentation/view%20model/recipe_cubit.dart';
import 'package:fishy/features/recipes/presentation/view/widgets/recipes_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseRecipesView extends StatelessWidget {
  const ChooseRecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.blueAccent,
            title: const Text('Recipes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ),
          body: RecipesGridView(),
        );
      },
    );
  }
}