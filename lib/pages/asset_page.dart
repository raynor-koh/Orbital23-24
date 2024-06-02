import 'package:flutter/material.dart';
import 'package:robinbank_app/components/candlestick_chart.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class AssetPage extends StatefulWidget {
  const AssetPage({super.key});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildPricePanel(context),
            const SizedBox(
              height: 8,
            ),
            buildMetricsPanel(context),
            const CandlestickChart(),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
        backgroundColor: UIColours.lightBackground,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AAPL',
                  style:  UIText.medium
                ),
                Text(
                  'Apple Inc NASDAQ',
                  style: UIText.small,
                ),
              ],
            ),
          ],          
        ),
    );
  }

  Widget buildPricePanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UIColours.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '192.25',
              style: UIText.heading,
            ),
            Row(
              children: [
                Text(
                  '+0.96',
                  style: UIText.small.copyWith(color: UIColours.green),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  '+0.50%',
                  style: UIText.small.copyWith(color: UIColours.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMetricsPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UIColours.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'High',
                  style: UIText.small,
                ),
                Text(
                  '192.57',
                  style: UIText.small,
                ),
                const SizedBox(
                  width: 100,
                  height: 8,
                ),
                Text(
                  '52 Week High',
                  style: UIText.small,
                ),
                Text(
                  '199.62',
                  style: UIText.small,
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Low',
                  style: UIText.small,
                ),
                Text(
                  '189.91',
                  style: UIText.small,
                ),
                const SizedBox(
                  width: 100,
                  height: 8,
                ),
                Text(
                  '52 Week Low',
                  style: UIText.small,
                ),
                Text(
                  '163.85',
                  style: UIText.small,
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(
                height: 100,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Volume',
                  style: UIText.small,
                ),
                Text(
                  '75.16M',
                  style: UIText.small,
                ),
                const SizedBox(
                  width: 100,
                  height: 8,
                ),
                Text(
                  'Mkt Cap',
                  style: UIText.small,
                ),
                Text(
                  '2.95T',
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
