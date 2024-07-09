import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailItem {
  final String title;
  final dynamic value;

  const DetailItem({
    required this.title,
    required this.value,
  });

  String get stringValue {
    if (value is DateTime) {
      return DateFormat.yMMMd().add_Hm().format((value as DateTime).toLocal());
    } else {
      return value.toString();
    }
  }
}

class DetailsList extends StatelessWidget {
  final List<DetailItem> items;

  const DetailsList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Détails',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8, width: double.infinity),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: items.map(
                (item) {
                  final border = item == items.last
                      ? BorderSide.none
                      : const BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        );
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: border
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(width: 8),
                          item.stringValue != ''
                            ? Text(
                              item.stringValue,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                            : Text(
                              'Non renseigné',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}