import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context).transactions;
    double totalIncome = transactions
        .where((t) => t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
    double totalExpense = transactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Statistics', style: TextStyle(color: Colors.black)),
        backgroundColor: CupertinoColors.white,
        border: Border.all(color: CupertinoColors.systemGrey, width: 0.5),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsCard(totalIncome, totalExpense),
              const SizedBox(height: 20),
              _buildPieChart(totalIncome, totalExpense),
            ],
          ),
        ),
      ),
    );
  }

  // 📌 Financial Overview Card with Premium Design
  Widget _buildStatsCard(double income, double expenses) {
    double balance = income - expenses;
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryTile("Income", income, CupertinoColors.activeGreen),
                _buildSummaryTile("Expenses", expenses, CupertinoColors.systemRed),
                _buildSummaryTile("Balance", balance, balance >= 0 ? CupertinoColors.systemYellow : CupertinoColors.systemRed),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Reusable Summary Tile with Premium Design
  Widget _buildSummaryTile(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Rs${amount.toStringAsFixed(2)}",
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // 📌 Pie Chart with Premium Design
  Widget _buildPieChart(double income, double expenses) {
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            const Text(
              'Spending Breakdown',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  sections: _buildPieChartSections(income, expenses),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendIndicator(CupertinoColors.activeGreen, "Income"),
                const SizedBox(width: 20),
                _legendIndicator(CupertinoColors.systemRed, "Expenses"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Pie Chart Data Sections with Premium Design
  List<PieChartSectionData> _buildPieChartSections(double income, double expenses) {
    return [
      PieChartSectionData(
        value: income,
        title: "Rs${income.toStringAsFixed(0)}",
        color: CupertinoColors.activeGreen,
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: expenses,
        title: "Rs${expenses.toStringAsFixed(0)}",
        color: CupertinoColors.systemRed,
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  // 📌 Legend Indicator with Premium Style
  Widget _legendIndicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
