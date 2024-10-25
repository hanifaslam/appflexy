class Receipt {
  final String companyName;
  final String companyAddress;
  final DateTime transactionDate;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final double amountPaid;
  final double change;

  Receipt({
    required this.companyName,
    required this.companyAddress,
    required this.transactionDate,
    required this.items,
    required this.totalAmount,
    required this.amountPaid,
    required this.change,
  });
}
