import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailItem {
  final String title;
  final dynamic value;
  final bool isEditable;
  final TextEditingController? controller;
  final bool obscureText;

  const DetailItem({
    required this.title,
    this.value,
    this.isEditable = false,
    this.obscureText = false,
    this.controller,
  });

  String get stringValue {
    if (value is DateTime) {
      return DateFormat.yMMMd().add_Hm().format((value as DateTime).toLocal());
    } else {
      return value.toString();
    }
  }
}

class DetailsList extends StatefulWidget {
  final Function()? onConfirmEdition;
  final bool hasEditRights;
  final List<DetailItem> items;

  const DetailsList({
    super.key,
    required this.items,
    this.hasEditRights = false,
    this.onConfirmEdition,
  });

  @override
  State<DetailsList> createState() => _DetailsListState();
}

class _DetailsListState extends State<DetailsList> {
  bool _isEdited = false;

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
              children: widget.items.map(
                (item) {
                  final border = item == widget.items.last
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
                          Row(
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              ...item.isEditable && widget.hasEditRights ? [
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Theme.of(context).hintColor,
                                ),
                              ] : [],
                            ],
                          ),
                          const SizedBox(width: 8),
                          item.value is! DateTime
                          ? SizedBox(
                            width: double.infinity,
                            height: 24,
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  _isEdited = true;
                                });
                              },
                              controller: item.value == null ? item.controller : TextEditingController(text: item.stringValue),
                              obscureText: item.obscureText,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Touchez pour modifier',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                              readOnly: !item.isEditable || !widget.hasEditRights,
                            ),
                          )
                          : item.stringValue != ''
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
        ..._isEdited
          ? [
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.onConfirmEdition?.call();
                  setState(() {
                    _isEdited = false;
                  });
                },
                child: const Text('Confirmer les modifications'),
              ),
            ),
          ]
          : [const SizedBox()],
      ],
    );
  }
}