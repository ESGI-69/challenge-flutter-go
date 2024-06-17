import 'package:flutter/material.dart';

class TripFeatureCard extends StatelessWidget {
  final bool? isLoading;
  final int? length;
  final String? emptyMessage;
  final Widget child;
  final IconData icon;
  final String title;

  const TripFeatureCard({
    super.key,
    this.isLoading = false,
    this.length = 0,
    this.emptyMessage = 'No elements',
    required this.child,
    required this.icon,
    required this.title,
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 16,
              ),
              child: isLoading!
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : length == 0
                      ? Center(
                          child: Text(emptyMessage!),
                        )
                      : child,
            ),
          ],
        ),
      ),
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(
      //     vertical: 8,
      //     horizontal: 12,
      //   ),
      //   child: isLoading!
      //       ? const Center(
      //           child: CircularProgressIndicator.adaptive(),
      //         )
      //       : length == 0
      //           ? Center(
      //               child: Text(emptyMessage!),
      //             )
      //           : child,
      // ),
    );
  }
}

class _Header extends StatelessWidget {
  final IconData icon;
  final String title;

  const _Header({
    required this.icon,
    required this.title,
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}