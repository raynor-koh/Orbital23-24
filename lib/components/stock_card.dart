import 'package:flutter/material.dart';
import 'package:robinbank_app/ui/ui_colours.dart';

class StockCard extends StatelessWidget {
  const StockCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: UIColours.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          'assets/images/Group_17.png',
        ),
      ),
    );
  }
}
