import 'package:flutter/material.dart';

class BottomShitHeaderAction {
  final String label;
  final Function() onPressed;
  final bool desctructive;

  BottomShitHeaderAction({
    required this.label,
    required this.onPressed,
    this.desctructive = false,
  });
}

class ModalBottomSheetHeader extends StatelessWidget {
  final String title;
  final List<BottomShitHeaderAction> actions;

  const ModalBottomSheetHeader({
    super.key,
    required this.title,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Fermer',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: PopupMenuButton(
                  enableFeedback: true,
                  position: PopupMenuPosition.under,
                  child: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  itemBuilder: (context) {
                    return actions.map((action) {
                      return PopupMenuItem(
                        onTap: action.onPressed,
                        child: Text(
                          action.label,
                          style: TextStyle(
                            color: action.desctructive ? Colors.red : null,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
