import 'package:fishy/features/recipes/data/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RecipeView extends StatelessWidget {
  const RecipeView({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recipe Details',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        foregroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          Image.network(
            recipe.photo!,
            fit: BoxFit.cover,
            height: 50.h,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                  width: double.infinity,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Origin: ',
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            recipe.origin!,
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Difficulty:',
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            height: 3.h,
                            child: ListView.builder(
                              itemBuilder: (_, index) {
                                return Container(
                                  width: 1.5.h,
                                  height: 1.5.h,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber,
                                  ),
                                );
                              },
                              itemCount: recipe.difficulty,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Ingredients:',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 86.w,
                                  child: Text(
                                    "- ${recipe.ingredients![index]}",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: recipe.ingredients!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Instructions:',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return Text(
                              "${index + 1}- ${recipe.instructions![index]}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                          itemCount: recipe.instructions!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
