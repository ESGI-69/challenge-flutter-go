import 'package:flutter/material.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card_grid_body.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card_full_body.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card_row_body.dart';

enum TripFeatureCardType {
  row,
  grid,
  full,
}

class TripFeatureCard extends StatelessWidget {
  final bool isLoading;
  final int length;
  final String emptyMessage;
  final IconData icon;
  final String title;
  final Function? onAddTap;
  final Function()? onTitleTap;
  final Widget? Function(BuildContext context, int index)? itemBuilder;
  final Widget? child;
  final bool showAddButton;
  final TripFeatureCardType type;

  const TripFeatureCard({
    super.key,
    this.isLoading = false,
    this.length = 0,
    this.emptyMessage = 'Pas d\'éléments',
    required this.icon,
    required this.title,
    this.onAddTap,
    this.onTitleTap,
    this.itemBuilder,
    this.child,
    this.showAddButton = false,
    this.type = TripFeatureCardType.row,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _Header(
            icon: icon,
            title: title,
            showAddButton: showAddButton,
            isLoading: isLoading,
            showTitleArrow: onTitleTap != null,
            onTitleTap: onTitleTap != null ? () => onTitleTap!() : null,
            onAddTap: onAddTap != null ? () => onAddTap!() : null,
          ),
          _BodySelector(
            type: type,
            isLoading: isLoading,
            length: length,
            emptyMessage: emptyMessage,
            itemBuilder: itemBuilder ?? (context, index) => const SizedBox(),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _BodySelector extends StatelessWidget {
  final TripFeatureCardType type;
  final bool isLoading;
  final int length;
  final String emptyMessage;
  final Widget? Function(BuildContext context, int index) itemBuilder;
  final Widget? child;

  const _BodySelector({
    required this.type,
    this.isLoading = false,
    this.length = 0,
    this.emptyMessage = 'No elements',
    required this.itemBuilder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TripFeatureCardType.row:
        return TripFeatureCardRowBody(
          isLoading: isLoading,
          length: length,
          emptyMessage: emptyMessage,
          itemBuilder: itemBuilder,
        );
      case TripFeatureCardType.grid:
        return TripFeatureCardGridBody(
          isLoading: isLoading,
          length: length,
          emptyMessage: emptyMessage,
          itemBuilder: itemBuilder,
        );
      case TripFeatureCardType.full:
        return TripFeatureCardFullBody(
          isLoading: isLoading,
          child: child,
        );
    }
  }
}

class _Header extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function? onTitleTap;
  final Function? onAddTap;
  final bool isLoading;
  final bool showAddButton;
  final bool showTitleArrow;

  const _Header({
    required this.icon,
    required this.title,
    required this.showAddButton,
    required this.showTitleArrow,
    this.onTitleTap,
    this.onAddTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                _HeaderTitle(
                  isLoading: isLoading,
                  title: title,
                  showArrow: showTitleArrow,
                  onTitleTap: !isLoading && onTitleTap != null ? () => onTitleTap!() : () {},
                ),
              ],
            ),
            ...isLoading || !showAddButton ? [] : [
              GestureDetector(
                onTap: onAddTap != null ? () => onAddTap!() : null,
                child: const Icon(
                  Icons.add,
                  size: 24,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  final bool isLoading;
  final String title;
  final Function onTitleTap;
  final bool showArrow;

  const _HeaderTitle({
    this.isLoading = false,
    required this.title,
    required this.onTitleTap,
    required this.showArrow,
  });

  _onTap() {
    if (!isLoading && showArrow) {
      onTitleTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...isLoading || !showArrow ? [] : [
            const SizedBox(width: 4),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ]
      ),
    );
  }
}
