import 'package:fishy/features/history/data/models/catch_day_model.dart';
import 'package:fishy/features/history/presentation/view%20model/history_cubit.dart';
import 'package:fishy/features/history/presentation/view/widgets/fish_list_item.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DayCategory extends StatelessWidget {
  const DayCategory({
    super.key,
    required this.catchDay,
    required this.cubit,
  });

  final CatchDay catchDay;
  final HistoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          catchDay.date,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        ...catchDay.catches.map((catchItem) {
          return FishListItem(cubit: cubit, catchItem: catchItem);
        }),
      ],
    );
  }
}
