import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Backoffice/Widgets/navigation_bar_backoffice.dart';
import 'package:move_together_app/Backoffice/Logs/bloc/logs_bloc.dart';
import 'package:move_together_app/Backoffice/Logs/logs_table.dart';

import 'package:move_together_app/Widgets/button.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  String? selectedFilter = '';
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavigationBarBackoffice(),
      body: BlocProvider(
          create: (context) =>
              LogsBloc(context)..add(LogsDataFetch(page: currentPage)),
          child: BlocBuilder<LogsBloc, LogsState>(builder: (context, state) {
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
                      'LOGS',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              value: selectedFilter,
                              items: <String>['', 'INFO', 'WARN', 'ERROR']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedFilter = newValue;
                                  currentPage = 1;
                                  context.read<LogsBloc>().add(LogsDataFetch(
                                      filter: selectedFilter,
                                      page: currentPage));
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: LogsTable(
                                logs: state.logs,
                              ),
                            ),
                            Text('Page $currentPage'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (currentPage > 1)
                                  Button(
                                    onPressed: () {
                                      setState(() {
                                        currentPage--;
                                        context.read<LogsBloc>().add(
                                            LogsDataFetch(
                                                filter: selectedFilter,
                                                page: currentPage));
                                      });
                                    },
                                    text: 'Previous',
                                  ),
                                if (state.logs.isNotEmpty)
                                  Button(
                                    onPressed: () {
                                      setState(() {
                                        currentPage++;
                                        context.read<LogsBloc>().add(
                                            LogsDataFetch(
                                                filter: selectedFilter,
                                                page: currentPage));
                                      });
                                    },
                                    text: 'Next',
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          })),
    );
  }
}
