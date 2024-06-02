import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/components/asset_card.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16,
          ),
          buildStatisticsPanel(context),
          const SizedBox(
            height: 8,
          ),
          buildIconButtonsPanel(context),
          const SizedBox(
            height: 8,
          ),
          Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Text(
              'Your Position(s)',
              style: UIText.large,
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
    );
  }

  Widget buildStatisticsPanel(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    log(user.email);
    return Container(
      decoration: BoxDecoration(
        color: UIColours.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 24, 8, 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Account Value ${user.name}',
              style: UIText.small.copyWith(color: UIColours.secondaryText),
            ),
            Text(
              '\$9,981.60',
              style: UIText.heading,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Market Value',
                      style:
                          UIText.small.copyWith(color: UIColours.secondaryText),
                    ),
                    Text(
                      '\$8,794.40',
                      style: UIText.medium,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buying Power',
                      style:
                          UIText.small.copyWith(color: UIColours.secondaryText),
                    ),
                    Text(
                      '\$1187.20',
                      style: UIText.medium,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day\'s P&L',
                      style:
                          UIText.small.copyWith(color: UIColours.secondaryText),
                    ),
                    Text(
                      '-18.40',
                      style: UIText.medium.copyWith(color: UIColours.red),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconButtonsPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UIColours.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.candlestick_chart_outlined,
                    size: 32,
                    color: UIColours.blue,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/searchpage');
                  },
                ),
                Text(
                  'Trade',
                  style: UIText.small,
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.receipt_long_outlined,
                    size: 32,
                    color: UIColours.blue,
                  ),
                  onPressed: () {},
                ),
                Text(
                  'Orders',
                  style: UIText.small,
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.analytics_outlined,
                    size: 32,
                    color: UIColours.blue,
                  ),
                  onPressed: () {},
                ),
                Text(
                  'Performance',
                  style: UIText.small,
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.restart_alt_outlined,
                    size: 32,
                    color: UIColours.blue,
                  ),
                  onPressed: () {},
                ),
                Text(
                  'Reset',
                  style: UIText.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
