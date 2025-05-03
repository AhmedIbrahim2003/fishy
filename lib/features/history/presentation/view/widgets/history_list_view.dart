import 'package:fishy/features/history/presentation/view%20model/history_cubit.dart';
import 'package:fishy/features/history/presentation/view/widgets/day_category.dart';
import 'package:flutter/material.dart';

class HistoryListView extends StatelessWidget {
  const HistoryListView({
    super.key,
    required this.cubit,
  });

  final HistoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: cubit.groupedCatches.length,
        itemBuilder: (context, index) {
          final catchDay = cubit.groupedCatches[index];
          return DayCategory(catchDay: catchDay, cubit: cubit);
        },
      ),
    );
  }
}
