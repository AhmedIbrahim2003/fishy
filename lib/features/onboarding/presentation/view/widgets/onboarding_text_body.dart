import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';



class OnboardingTextBody extends StatelessWidget {
  const OnboardingTextBody({
    super.key,
    required this.bodyText,
  });

  final String bodyText;

  @override
  Widget build(BuildContext context) {
    String fullText = bodyText;
    String specialWord = "InterVysor";
    int index = fullText.indexOf(specialWord);

    return ConditionalBuilder(
      condition: index != -1,
      builder: (context) => RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Color(0xFF27273A),
              ),
          children: [
            TextSpan(
              text: fullText.substring(0, index),
            ),
            TextSpan(
              text: specialWord,
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: fullText.substring(index + specialWord.length),
            ),
          ],
        ),
        maxLines: 4,
      ),
      fallback: (context) => Text(
        fullText,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Color(0xFF27273A),
            ),
        maxLines: 4,
      ),
    );
  }
}