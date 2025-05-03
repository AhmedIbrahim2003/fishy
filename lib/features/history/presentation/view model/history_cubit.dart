import 'dart:io';

import 'package:fishy/features/history/presentation/view/widgets/results_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/data/json/fish_info.dart';
import '../../../../core/utils/database_helper.dart';
import '../../../../core/data/model/fish_model.dart';
import '../../data/models/catch_day_model.dart';
import '../../data/models/catch_model.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial()) {
    getGroupedCatches();
  }
  static HistoryCubit get(context) => BlocProvider.of(context, listen: false);

  List<CatchDay> groupedCatches = [];

  Future<void> getGroupedCatches() async {
    try {
      emit(GetGroupedCatchesLoading());
      final db = await DatabaseHelper.instance.database;
      final allRows = await db.query('saved_catchs');

      Map<String, List<Catch>> grouped = {};

      for (var row in allRows) {
        final catchItem = Catch.fromJson(row);
        final dateKey = DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(catchItem.timestamp));

        grouped.putIfAbsent(dateKey, () => []).add(catchItem);
      }

      List<CatchDay> groupedList = grouped.entries.map((entry) {
        // Sort the catches in each date group by timestamp descending
        entry.value.sort((a, b) =>
            DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

        return CatchDay(date: entry.key, catches: entry.value);
      }).toList();

      // Sort groups by date descending (newest first)
      groupedList.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

      groupedCatches = groupedList;
      emit(GetGroupedCatchesSuccess());
    } catch (e) {
      emit(GetGroupedCatchesError(errorMessage: e.toString()));
    }
  }

  String getTimeOnly(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  void showDetailsBottomSheet(
      {required BuildContext context,
      required Catch fishCatch,
      required String fishName,
      required HistoryCubit cubit}) {
    final fishType = _searchFishByName(fishName);
    detailsBottomSheet(
      context: context,
      fishCatch: fishCatch,
      fishType: fishType!,
      cubit: cubit,
    );
  }

  Fish? _searchFishByName(String name) {
    final fishes = fishInfo.map((json) => Fish.fromJson(json)).toList();
    return fishes.firstWhere(
      (fish) => fish.name.toLowerCase() == name.toLowerCase(),
      orElse: () => Fish(
        name: '',
        poisonous: false,
        popularRegions: [],
      ),
    );
  }

  Future<void> deleteCatch({required BuildContext context, required int id, required String photoPath}) async {
    try {
      emit(DeletingCatchLoading());
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
      await DatabaseHelper.instance.deleteCatch(id);
      Navigator.pop(context);
      emit(DeletingCatchSuccess());
      await getGroupedCatches();
    } catch (e) {
      emit(DeletingCatchError(errorMessage: e.toString()));
    }
  }
}
