import 'dart:math';

import 'package:charts_tutorial/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarCharts extends StatelessWidget {
  const BarCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              SizedBox(height: defaultPadding),
              Center(
                child: Text(
                  "Vertical Bar Chart",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              SizedBox(height: defaultPadding),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: chartData.length * 80,
                  height: 300, // Sesuaikan tinggi sesuai kebutuhan
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      isVisible: true,
                      labelPlacement: LabelPlacement.betweenTicks,
                      majorGridLines: MajorGridLines(width: 0),
                      majorTickLines: MajorTickLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(isVisible: false, interval: 1),
                    series: <CartesianSeries>[
                      ColumnSeries<ChartData, String>(
                        color: Colors.amber,
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        width: 0.8, // Lebar bar
                        spacing: 0.2, // Jarak antar bar
                      ),
                      ColumnSeries<ChartData, String>(
                        color: Colors.blue,
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.z,
                        width: 0.8, // Lebar bar
                        spacing: 0.2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.z);
  final String x;
  final double y;
  final double z;
}

// Sample data dengan lebih banyak item
final List<ChartData> chartData = [
  ChartData('Jakarta', 10, 0.2),
  ChartData('Bali', 20, 4),
  ChartData('Cikupa', 15, 67),
  ChartData('Depok', 25, 4),
  ChartData('Surabaya', 18, 6),
  ChartData('Bandung', 22, 19),
  ChartData('Yogyakarta', 12, 23),
  ChartData('Semarang', 17, 1),
  ChartData('Medan', 14, 11),
  ChartData('Makassar', 19, 5),
  // Tambahkan lebih banyak data sesuai kebutuhan
];