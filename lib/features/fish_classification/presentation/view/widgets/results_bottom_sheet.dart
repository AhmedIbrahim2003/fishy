import 'dart:io';
import 'dart:ui';

import 'package:fishy/core/data/model/fish_model.dart';
import 'package:fishy/features/fish_classification/presentation/view%20model/fish_classifier_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../../recipes/presentation/view model/recipe_cubit.dart';
import '../../../../recipes/presentation/view/choose_recipes_view.dart';

Future<dynamic> resultsBottomSheet(
    {required BuildContext context,
    required File? imageFile,
    required Fish fish,
    required double confidence}) {
  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => BlocProvider(
      create: (context) => FishClassifierCubit(),
      child: BlocBuilder<FishClassifierCubit, FishClassifierState>(
        builder: (context, state) {
          var cubit = FishClassifierCubit.get(context);
          bool isSaved = cubit.isCatchSaved();
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Lottie.asset(
                      'assets/lottie/waves.json',
                      frameRate: FrameRate.max,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (imageFile != null)
                              Container(
                                height: 300,
                                width: double.infinity,
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.file(
                                  imageFile,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Fish Classification Results',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Species:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          Text(
                                            fish.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontSize: 20.sp,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text('Safety:',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!),
                                          Text(
                                            fish.poisonous
                                                ? 'Poisonous'
                                                : 'Safe',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  color: fish.poisonous
                                                      ? Colors.red
                                                      : Colors.green,
                                                  fontSize: 20.sp,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Popular Regions:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!),
                                  Text(fish.popularRegions.join(', '),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Confidence: $confidence%',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 15,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(250, 40),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) =>
                                        RecipeCubit(fishName: fish.name),
                                    child: const ChooseRecipesView(),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageIcon(
                                  AssetImage("assets/icons/recipe_icon.png"),
                                  color: Colors.blueAccent,
                                  size: 20.sp,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Discover Recipes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent),
                                ),
                              ],
                            )),
                        ElevatedButton(
                            onPressed: () async {
                              if (isSaved) {
                                await cubit.deleteCatch();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Catch deleted successfully'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                await cubit.saveCatch(
                                  fishName: fish.name,
                                  photoPath: imageFile!.path,
                                  confidence: confidence,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Catch saved successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            child: isSaved
                                ? Icon(
                                    Icons.turned_in,
                                    color: Colors.amber,
                                  )
                                : Icon(Icons.turned_in_not)),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
