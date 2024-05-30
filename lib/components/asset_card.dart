import 'package:flutter/material.dart';
import 'package:robinbank_app/ui/ui_colours.dart';

class AssetCard extends StatelessWidget {
  const AssetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 9),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: UIColours.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: UIColours.surfaceMuted),
          ),
          child: Image.asset(
            'assets/images/Group_17.png',
          ),
        ),
      ),
    );
  }
}