import 'package:fishy/features/recipes/presentation/view/widgets/fish_grid_view.dart';
import 'package:flutter/material.dart';

class FishSelectView extends StatelessWidget {
  const FishSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.blueAccent,
        title: const Text(
          'Recipes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FishGridView(),
    );
  }
}
