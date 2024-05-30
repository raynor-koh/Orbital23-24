import 'package:flutter/material.dart';
import 'package:robinbank_app/components/asset_card.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'RobinBank',
                  style: UIText.brand,
                ),
                Text(
                  'Your Balance',
                  style: UIText.large,
                ),
                Text(
                  '\$2,756.40',
                  style: UIText.heading,
                ),
                Text(
                  '+3.68%',
                  style: UIText.medium.copyWith(color: UIColours.green),
                ),
              ],
            ),
            Image.asset(
              'assets/images/Graph.png',
              height: 150,
            ),
            Align(
              alignment: const AlignmentDirectional(-1, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                child: Text(
                  'Your assets',
                  style: UIText.large,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                scrollDirection: Axis.vertical,
                children: const [
                  AssetCard(),
                  AssetCard(),
                  AssetCard(),
                  AssetCard(),
                  AssetCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
