class Transaction {
  final int? id;
  final String name;
  final double amount;
  final bool isIncome;
  final String category;
  final DateTime date;

  Transaction({
    this.id,
    required this.name,
    required this.amount,
    required this.isIncome,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'isIncome': isIncome ? 1 : 0,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      isIncome: map['isIncome'] == 1,
      category: map['category'],
      date: DateTime.parse(map['date']),
    );
  }
}

