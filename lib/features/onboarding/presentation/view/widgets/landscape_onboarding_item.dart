import 'package:flutter/material.dart';

import '../../../data/models/onboarding_model.dart';

class LandscapeOnboardingItem extends StatelessWidget {
  const LandscapeOnboardingItem({
    super.key,
    required this.onboardingModel,
  });

  final OnboardingModel onboardingModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(onboardingModel.image),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                onboardingModel.title,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.blueAccent,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                onboardingModel.bodyText,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: const Color.fromARGB(255, 88, 88, 88),
                    ),
                maxLines: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
