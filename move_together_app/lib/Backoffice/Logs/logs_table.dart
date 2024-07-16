import 'package:flutter/material.dart';
import 'package:move_together_app/core/models/log.dart';

Map<LogLevel, String> logLevelToString = {
  LogLevel.INFO: 'INFO',
  LogLevel.ERROR: 'ERROR',
  LogLevel.WARN: 'WARNING',
};


class LogsTable extends StatelessWidget {
  final List<Log> logs;

  const LogsTable({
    super.key,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Table(
            border: TableBorder.all(
                color: const Color(0xFF81C784),
                width: 2,
                borderRadius: const BorderRadius.all(Radius.elliptical(10, 10))),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              const TableRow(
                decoration: BoxDecoration(
                  color: Color(0xFFB9F6CA),
                ),
                children: [
                  TableCell(child: Center(child: Text('Timestamp'))),
                  TableCell(child: Center(child: Text('ID'))),
                  TableCell(child: Center(child: Text('Level'))),
                  TableCell(child: Center(child: Text('Message'))),
                  TableCell(child: Center(child: Text('IP'))),
                  TableCell(child: Center(child: Text('Path'))),
                  TableCell(child: Center(child: Text('Method'))),
                  TableCell(child: Center(child: Text('Username'))),
                ],
              ),
              for (final log in logs)
                TableRow(
                  children: [
                    TableCell(child: Center(child: Text(log.timestamp.toLocal().toString()))),
                    TableCell(child: Center(child: Text(log.id.toString()))),
                    TableCell(child: Center(child: Text(logLevelToString[log.level]!))),
                    TableCell(child: Center(child: Text(log.message))),
                    TableCell(child: Center(child: Text(log.ip))),
                    TableCell(child: Center(child: Text(log.path))),
                    TableCell(child: Center(child: Text(log.method))),
                    TableCell(child: Center(child: Text(log.username))),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}