import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false; // To track loading state

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  // Fetch all transactions from the database
  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _transactions = await DBHelper.getTransactions();
    } catch (e) {
      // Handle error, show a message or log it
      print('Error fetching transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new transaction to the database and list
  Future<void> addTransaction(Transaction transaction) async {
    try {
      await DBHelper.insertTransaction(transaction);
      _transactions.add(transaction); // Add to local list immediately
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error adding transaction: $e');
    }
  }

  // Delete a transaction from the database and list
  Future<void> deleteTransaction(int id) async {
    try {
      await DBHelper.deleteTransaction(id);
      _transactions.removeWhere((transaction) => transaction.id == id); // Remove from local list
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error deleting transaction: $e');
    }
  }

  // Update a transaction in the database and the local list
  Future<void> updateTransaction(Transaction updatedTransaction) async {
    try {
      await DBHelper.updateTransaction(updatedTransaction); // Update in DB
      final index = _transactions.indexWhere((transaction) => transaction.id == updatedTransaction.id);
      if (index != -1) {
        _transactions[index] = updatedTransaction; // Update locally
        notifyListeners();
      }
    } catch (e) {
      // Handle error
      print('Error updating transaction: $e');
    }
  }
}
