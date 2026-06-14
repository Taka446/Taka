import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/asset_snapshot.dart';

class AssetChart extends StatelessWidget {
  final List<AssetSnapshot> snapshots;
  final List<MapEntry<DateTime, double>>? projected;

  const AssetChart({super.key, required this.snapshots, this.projected});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sorted = [...snapshots]..sort((a, b) => a.date.compareTo(b.date));

    final actualSpots = sorted.asMap().entries.map((e) =>
        FlSpot(e.key.toDouble(), e.value.totalAmount / 10000)).toList();

    final projectedSpots = projected != null
        ? projected!.asMap().entries.map((e) =>
            FlSpot(sorted.length + e.key.toDouble(),
                e.value.value / 10000)).toList()
        : <FlSpot>[];

    final allValues = [
      ...actualSpots.map((s) => s.y),
      ...projectedSpots.map((s) => s.y),
    ];
    final maxY = allValues.isEmpty ? 1000.0 : allValues.reduce((a, b) => a > b ? a : b);

    return LineChart(LineChartData(
      minY: 0,
      maxY: maxY * 1.1,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (v, _) => Text(
              '${v.toInt()}万',
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) {
              final idx = v.toInt();
              if (idx < 0 || idx >= sorted.length) return const SizedBox();
              if (idx % (sorted.length ~/ 4 + 1) != 0) return const SizedBox();
              return Text(DateFormat('yy/M').format(sorted[idx].date),
                  style: const TextStyle(fontSize: 10));
            },
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: actualSpots,
          isCurved: true,
          color: scheme.primary,
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: scheme.primary.withOpacity(0.1),
          ),
        ),
        if (projectedSpots.isNotEmpty)
          LineChartBarData(
            spots: projectedSpots,
            isCurved: true,
            color: scheme.tertiary,
            barWidth: 2,
            dashArray: [6, 4],
            dotData: const FlDotData(show: false),
          ),
      ],
    ));
  }
}
