import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  bool _isIncome = false;
  final TextEditingController _customCategoryController = TextEditingController();

  void _addTransaction() {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text);
    if (name.isEmpty || amount == null || amount <= 0) {
      _showErrorDialog("Please enter valid transaction details.");
      return;
    }

    final transaction = Transaction(
      name: name,
      amount: amount,
      isIncome: _isIncome,
      category: _selectedCategory,
      date: DateTime.now(),
    );

    Provider.of<TransactionProvider>(context, listen: false).addTransaction(transaction);
    Navigator.pop(context);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invalid Input"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Colors.white; // Set background to white for Apple-like feel
    final textColor = Colors.black; // Use black text for better contrast

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Transaction Name", _nameController, Icons.edit),
            const SizedBox(height: 16),
            _buildTextField("Amount", _amountController, Icons.attach_money, isNumber: true),
            const SizedBox(height: 16),
            _buildCategoryDropdown(),
            if (_selectedCategory == 'Others') _buildCustomCategoryField(),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text("Is Income?", style: TextStyle(fontSize: 16)),
              value: _isIncome,
              activeColor: Colors.green,
              onChanged: (value) => setState(() => _isIncome = value),
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addTransaction,
                icon: const Icon(Icons.add),
                label: const Text("Add Transaction"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16),
        prefixIcon: Icon(icon, color: Colors.black.withOpacity(0.7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: "Category",
        labelStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items: ['Food', 'Transport', 'Shopping', 'Entertainment', 'Others']
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      onChanged: (value) => setState(() => _selectedCategory = value!),
    );
  }

  Widget _buildCustomCategoryField() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextField(
        controller: _customCategoryController,
        decoration: InputDecoration(
          labelText: "Custom Category",
          labelStyle: const TextStyle(fontSize: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}
