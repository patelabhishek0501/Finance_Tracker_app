import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/transaction.dart';
import '../database/db_helper.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = "All";
  String _selectedSort = "Newest First";
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // Function to load transactions
  Future<void> _loadTransactions() async {
    final transactions = await DBHelper.getTransactions();
    setState(() {
      _transactions = transactions;
      _filteredTransactions = transactions;
      _isLoading = false;
    });
  }

  // Filter transactions based on the search query
  void _filterTransactions(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTransactions = _transactions
          .where((t) =>
              t.name.toLowerCase().contains(query.toLowerCase()) ||
              t.date.toString().contains(query))
          .toList();
    });
  }

  // Apply filters for income, expense, and sorting
  void _applyFilters() {
    setState(() {
      _filteredTransactions = _transactions.where((t) {
        if (_selectedFilter == "Income") return t.isIncome;
        if (_selectedFilter == "Expense") return !t.isIncome;
        return true;
      }).toList();

      if (_selectedSort == "Amount: High to Low") {
        _filteredTransactions.sort((a, b) => b.amount.compareTo(a.amount));
      } else if (_selectedSort == "Amount: Low to High") {
        _filteredTransactions.sort((a, b) => a.amount.compareTo(b.amount));
      } else {
        _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
      }
    });
  }

  // Generate PDF of transactions
  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Wallet Transactions", style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 16),
            ..._filteredTransactions.map((t) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(t.name, style: pw.TextStyle(fontSize: 14)),
                        pw.Text(DateFormat.yMMMd().format(t.date),
                            style: pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.Text(
                      '₹${t.amount.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color:
                            t.isIncome ? PdfColors.black : PdfColors.grey800,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Search bar for transactions
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: CupertinoSearchTextField(
        onChanged: _filterTransactions,
        placeholder: 'Search Transactions',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  // Filter options for income, expense, and sorting
  Widget _buildFilterOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CupertinoButton(
          child: const Text("Filters", style: TextStyle(color: Colors.black)),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (_) => CupertinoActionSheet(
                title: const Text("Filter by Type"),
                actions: [
                  for (var filter in ["All", "Income", "Expense"])
                    CupertinoActionSheetAction(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = filter;
                          _applyFilters();
                        });
                        Navigator.pop(context);
                      },
                      child: Text(filter),
                    ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text("Sort", style: TextStyle(color: Colors.black)),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (_) => CupertinoActionSheet(
                title: const Text("Sort Transactions"),
                actions: [
                  for (var sort in [
                    "Newest First",
                    "Amount: High to Low",
                    "Amount: Low to High"
                  ])
                    CupertinoActionSheetAction(
                      onPressed: () {
                        setState(() {
                          _selectedSort = sort;
                          _applyFilters();
                        });
                        Navigator.pop(context);
                      },
                      child: Text(sort),
                    ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            );
          },
        ),
        CupertinoButton(
          onPressed: _generatePdf,
          child: const Icon(CupertinoIcons.share, color: Colors.black),
        ),
      ],
    );
  }

  // Transaction list builder
  Widget _buildTransactionList() {
    if (_isLoading) return const Center(child: CupertinoActivityIndicator());

    if (_filteredTransactions.isEmpty) {
      return const Center(child: Text("No transactions found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      itemCount: _filteredTransactions.length,
      itemBuilder: (context, index) {
        final t = _filteredTransactions[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Text(DateFormat.yMMMd().format(t.date),
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 12)),
              ]),

              Text(
                "₹${t.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: t.isIncome ? CupertinoColors.activeGreen : CupertinoColors.systemRed,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Main build method
  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return CupertinoPageScaffold(
      backgroundColor: isDarkMode ? CupertinoColors.black : CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Wallet", style: TextStyle(color: Colors.black)),
        backgroundColor: CupertinoColors.white,
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilterOptions(),
            const SizedBox(height: 4),
            Expanded(
              child: RefreshIndicator(
                color: CupertinoColors.activeBlue, // Blue color for the circular indicator
                displacement: 40, // Control the distance from the top
                onRefresh: _loadTransactions, // The function triggered when pull-to-refresh is activated
                child: _isLoading
                    ? const CupertinoActivityIndicator() // Show Cupertino-style loading indicator while refreshing
                    : _buildTransactionList(), // Show transactions when not refreshing
              ),
            )

          ],
        ),
      ),
    );
  }
}
