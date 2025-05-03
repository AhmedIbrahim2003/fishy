import 'dart:io';

import 'package:fishy/features/history/data/models/catch_day_model.dart';
import 'package:fishy/features/history/presentation/view%20model/history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../data/models/catch_model.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'Your Catch History',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            var cubit = HistoryCubit.get(context);
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetGroupedCatchesSuccess) {
              if (cubit.groupedCatches.isEmpty) {
                return const EmptyListView();
              } else {
                return HistoryListView(cubit: cubit);
              }
            } else if (state is GetGroupedCatchesError) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class EmptyListView extends StatelessWidget {
  const EmptyListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lottie/fishing.json',
          frameRate: FrameRate.max,
        ),
        Text(
          'No catches found',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Start catching fish now!',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

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
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
        ),
        ...catchDay.catches.map((catchItem) {
          return FishListItem(cubit: cubit, catchItem: catchItem);
        }),
      ],
    );
  }
}

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
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
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
