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

  const TripFeatureCard({
    super.key,
    this.isLoading = false,
    this.length = 0,
    this.emptyMessage = 'No elements',
    required this.icon,
    required this.title,
    this.onAddTap,
    this.onTitleTap,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        child: Column(
          children: [
            _Header(
              icon: icon,
              title: title,
              isLoading: isLoading,
              onTitleTap: onTitleTap != null ? () => onTitleTap!() : null,
              onAddTap: onAddTap != null ? () => onAddTap!() : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 16,
              ),
              child: isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : length == 0
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: Text(
                          emptyMessage,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
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
            ),
          ],
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

  const _Header({
    required this.icon,
    required this.title,
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
                  onTitleTap: !isLoading && onTitleTap != null ? () => onTitleTap!() : () {},
                ),
              ],
            ),
            ...isLoading ? [] : [
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

  const _HeaderTitle({
    this.isLoading = false,
    required this.title,
    required this.onTitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTitleTap(),
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
          ...isLoading ? [] : [
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
