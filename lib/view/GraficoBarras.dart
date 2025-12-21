import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Graficobarras extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const Graficobarras({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(15),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY:
              (data
                      .map((e) => e['ebikes'] + e['mecanicas'])
                      .reduce((a, b) => a > b ? a : b))
                  .toDouble() +
              2,
          barGroups: data.asMap().entries.map((entry) {
            int i = entry.key;
            final estacion = entry.value;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: (estacion['mecanicas'] as int).toDouble(),
                  width: 15,
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: (estacion['ebikes'] as int).toDouble(),
                  width: 15,
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < data.length) {
                    return Text(
                      data[value.toInt()]['nombre'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
