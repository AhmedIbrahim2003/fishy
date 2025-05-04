import 'dart:io';
import 'package:fishy/features/history/data/models/catch_model.dart';
import 'package:fishy/features/history/presentation/view%20model/history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FishListItem extends StatelessWidget {
  const FishListItem({
    super.key,
    required this.cubit,
    required this.catchItem,
  });

  final HistoryCubit cubit;
  final Catch catchItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        cubit.showDetailsBottomSheet(
          context: context,
          fishCatch: catchItem,
          fishName: catchItem.fishName,
          cubit: cubit,
        );
      },
      child: Container(
        width: double.infinity,
        height: 30.h,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(
              File(catchItem.photoPath),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 20.h,
            ),
            Text(
              'Fish Type: ${catchItem.fishName}',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent),
            ),
            Text(
              'Time of the catch: ${cubit.getTimeOnly(catchItem.timestamp)}',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
