import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripCostTag extends StatelessWidget {
  final double totalCost;

  const TripCostTag({
    super.key,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Center(
        child: Text(
          NumberFormat.compactCurrency(
                  symbol: NumberFormat.simpleCurrency().currencySymbol)
              .format(totalCost),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
