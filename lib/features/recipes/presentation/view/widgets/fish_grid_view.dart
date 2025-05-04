import 'dart:developer';

import 'package:fishy/features/recipes/presentation/view%20model/recipe_cubit.dart';
import 'package:fishy/features/recipes/presentation/view/widgets/fish_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class FishGridView extends StatelessWidget {
  const FishGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCubit, RecipeState>(
      builder: (context, state) {
        var cubit = RecipeCubit.get(context);
        return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              mainAxisExtent: 23.h,
            ),
            itemCount: cubit.everyRecipes.length,
            itemBuilder: (context, index) {
              log(cubit.everyRecipes[index].name??'no name');
              log(cubit.everyRecipes[index].photo??'no photo');
              return FishCard(
                fishName:
                    cubit.everyRecipes[index].name ?? '',
                fishPhoto:
                    cubit.everyRecipes[index].photo ?? '',
              );
            });
      },
    );
  }
}
