import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../data/models/onboarding_model.dart';

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({
    super.key,
    required this.pageController,
    required this.onboardingList,
  });

  final PageController pageController;
  final List<OnboardingModel> onboardingList;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      effect: const ExpandingDotsEffect(
        dotColor: Color(0xffD9D9D9),
        activeDotColor: Colors.blueAccent,
        dotHeight: 10.43,
        dotWidth: 10.43,
        expansionFactor: 2.9,
        spacing: 7.49,
      ),
      controller: pageController,
      count: onboardingList.length,
    );
  }
}
