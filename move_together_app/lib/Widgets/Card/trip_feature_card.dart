import 'package:flutter/material.dart';

class TripFeatureCard extends StatelessWidget {
  final bool isLoading;
  final int length;
  final String emptyMessage;
  final IconData icon;
  final String title;
  final Function? onAddTap;
  final Function? onTitleTap;
  final Widget? Function(BuildContext context, int index) itemBuilder;
  final bool showAddButton;
  final bool showTitleArrow;
  final bool isFullGridView;

  const TripFeatureCard({
    super.key,
    this.isLoading = false,
    this.length = 0,
    this.emptyMessage = 'Pas d\'éléments',
    required this.icon,
    required this.title,
    this.onAddTap,
    this.onTitleTap,
    required this.itemBuilder,
    this.showAddButton = false,
    this.showTitleArrow = false,
    this.isFullGridView = false,
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
            showTitleArrow: showTitleArrow,
            onTitleTap: onTitleTap != null ? () => onTitleTap!() : null,
            onAddTap: onAddTap != null ? () => onAddTap!() : null,
          ),
          isFullGridView
            ? _GridBody(
              isLoading: isLoading,
              length: length,
              emptyMessage: emptyMessage,
              itemBuilder: itemBuilder,
            )
            : _RowBody(
              isLoading: isLoading,
              length: length,
              emptyMessage: emptyMessage,
              itemBuilder: itemBuilder,
            ),
        ],
      ),
    );
  }
}

class _RowBody extends StatelessWidget {
  final bool isLoading;
  final int length;
  final String emptyMessage;
  final Widget? Function(BuildContext context, int index) itemBuilder;

  const _RowBody({
    this.isLoading = false,
    this.length = 0,
    required this.emptyMessage,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 6,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      child: isLoading
        ? const Center(
            child: CircularProgressIndicator.adaptive(),
          )
        : length == 0
          ? _EmptyBody(message: emptyMessage)
          : ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 125),
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: length,
              itemBuilder: itemBuilder,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            )
          )
    );
  }
}

class _GridBody extends StatelessWidget {
  final bool isLoading;
  final int length;
  final String emptyMessage;
  final Widget? Function(BuildContext context, int index) itemBuilder;

  const _GridBody({
    this.isLoading = false,
    this.length = 0,
    this.emptyMessage = 'No elements',
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(
          child: CircularProgressIndicator.adaptive(),
        )
      : length == 0
        ? Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 16,
          ),
          child: _EmptyBody(message: emptyMessage),
        )
        : ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemCount: length,
            itemBuilder: itemBuilder,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
          ),
        );
  }
}

class _EmptyBody extends StatelessWidget {
  final String message;

  const _EmptyBody({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
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
