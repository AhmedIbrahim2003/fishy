import 'package:flutter/material.dart';


import '../../../data/models/onboarding_model.dart';
import 'onboarding_text_body.dart';

class PortraitOnboardingItem extends StatelessWidget {
  const PortraitOnboardingItem({
    super.key,
    required this.onboardingModel,
  });

  final OnboardingModel onboardingModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(flex: 1),
        Image.asset(onboardingModel.image,
            height: MediaQuery.sizeOf(context).height * 0.55),
        Spacer(flex: 2),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                onboardingModel.title,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Color(0xFF27273A),
                      fontSize: 32,
                    ),
              ),
              const SizedBox(height: 17),
              OnboardingTextBody(bodyText: onboardingModel.bodyText),
            ],
          ),
        ),
      ],
    );
  }
}
