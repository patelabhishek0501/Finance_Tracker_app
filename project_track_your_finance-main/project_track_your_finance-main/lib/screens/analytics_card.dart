import 'package:flutter/material.dart';

class ExpenseTrackerCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpenses;
  final double balance;

  const ExpenseTrackerCard({
    super.key,
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        height: 240, // Slightly taller for more breathing space
        decoration: BoxDecoration(
          color: Colors.white, // Neutral white background
          borderRadius: BorderRadius.circular(28), // Smooth rounded corners for a refined feel
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Light subtle shadow for depth
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row with Apple-style minimalism
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Financial Overview",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600, // Apple-like sleekness
                    ),
                  ),
                  Icon(Icons.account_balance_wallet, color: Colors.blueGrey), // Subtle gray-blue accent
                ],
              ),

              const SizedBox(height: 12),

              // Balance Display with larger font and Apple-like minimalistic touch
              Center(child: _buildInfo("Balance", balance, Colors.black, 28, FontWeight.w700)),

              const SizedBox(height: 24),

              // Income & Expenses Row with a more neutral design
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfo("Income", totalIncome, Colors.green, 20, FontWeight.w600), // Subtle green for income
                  _buildInfo("Expenses", totalExpenses, Colors.redAccent, 20, FontWeight.w600), // Soft red for expenses
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Info Widget with minimalist design
  Widget _buildInfo(String label, double amount, Color color, double fontSize, FontWeight fontWeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "₹${amount.toStringAsFixed(2)}",
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: 0.5, // Subtle letter spacing for clarity
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54, // Light gray color for labels for contrast
            fontSize: 14, // Smaller label size for better balance
          ),
        ),
      ],
    );
  }
}
