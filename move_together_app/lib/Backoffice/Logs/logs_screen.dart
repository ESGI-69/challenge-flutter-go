import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Backoffice/Widgets/navigation_bar_backoffice.dart';
import 'package:move_together_app/Backoffice/Logs/bloc/logs_bloc.dart';
import 'package:move_together_app/Backoffice/Logs/logs_table.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationBarBackoffice(),
      body: BlocProvider(
        create: (context) => LogsBloc(context)..add(LogsDataFetch()),
        child: BlocBuilder<LogsBloc, LogsState>(
          builder: (context, state) {
            if (state is LogsDataLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is LogsDataLoadingError) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else if (state is LogsDataLoadingSuccess) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'LOGS SCREEN',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LogsTable(
                        logs: state.logs,
                      ),
                    )
                  ],
                ),
              );
            }
            return const SizedBox();
          }
        )
      ),
    );
  }
}
