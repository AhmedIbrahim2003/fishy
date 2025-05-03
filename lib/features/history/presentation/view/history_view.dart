import 'package:fishy/features/history/presentation/view%20model/history_cubit.dart';
import 'package:fishy/features/history/presentation/view/widgets/empty_list_view.dart';
import 'package:fishy/features/history/presentation/view/widgets/history_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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