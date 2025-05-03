import 'dart:io';
import 'dart:ui';

import 'package:fishy/core/data/model/fish_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../data/models/catch_model.dart';
import '../../view model/history_cubit.dart';

Future<dynamic> detailsBottomSheet({
  required BuildContext context,
  required Catch fishCatch,
  required Fish fishType,
  required HistoryCubit cubit,
}) {
  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
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
                      Container(
                        height: 300,
                        width: double.infinity,
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.file(
                          File(fishCatch.photoPath),
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
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      fishType.name,
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
                                      fishType.poisonous ? 'Poisonous' : 'Safe',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: fishType.poisonous
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
                                style:
                                    Theme.of(context).textTheme.titleMedium!),
                            Text(fishType.popularRegions.join(', '),
                                style:
                                    Theme.of(context).textTheme.titleMedium!),
                            const SizedBox(height: 8),
                            Text(
                              'Confidence: ${fishCatch.confidence}%',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    cubit.deleteCatch(
                      context: context,
                      id: fishCatch.id,
                      photoPath: fishCatch.photoPath,
                    );
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    ),
  );
}
