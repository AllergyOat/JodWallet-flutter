import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../database/model.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionResultScreen extends StatefulWidget {
  const TransactionResultScreen({super.key});

  @override
  _TransactionResultScreenState createState() =>
      _TransactionResultScreenState();
}

class _TransactionResultScreenState extends State<TransactionResultScreen> {
  int totalIncome = 100;
  int totalOutcome = 100;
  String type = 'saving';
  bool showSavingText = true;
  bool showExpenseText = false;
  FirebaseService firebaseService = FirebaseService();
  List<Transaction>? filteredTransactions;

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 30, 56),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 250, 212, 79),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          title: Text(
            'Transaction Results',
            style: GoogleFonts.outfit(
              textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  selectedDate =
                      DateTime(selectedDate.year, selectedDate.month - 1);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  selectedDate =
                      DateTime(selectedDate.year, selectedDate.month + 1);
                });
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 241, 244, 250),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Income section (รายรับ)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_downward,
                          color: Color.fromARGB(255, 111, 130, 148),
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'รายรับ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '+${totalIncome.toInt()}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // เส้นแบ่งระหว่างรายรับและรายจ่าย
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        width: 1,
                        height: 25,
                        color: const Color.fromARGB(255, 111, 130, 148),
                      ),
                    ),
                    // Outcome section (รายจ่าย)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          color: Color.fromARGB(255, 111, 130, 148),
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'รายจ่าย',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '  ${totalOutcome.toInt()}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 60,
                      decoration: BoxDecoration(
                        color: type == 'saving'
                            ? const Color.fromARGB(255, 1, 30, 56)
                            : const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.download,
                              color: type == 'saving'
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : const Color.fromARGB(255, 1, 30, 56),
                            ),
                            onPressed: () {
                              setState(() {
                                type = 'saving';
                                showSavingText = true;
                                showExpenseText = false;
                              });
                            },
                          ),
                          if (showSavingText)
                            const Text(
                              'รายรับ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 60,
                      decoration: BoxDecoration(
                        color: type == 'expense'
                            ? const Color.fromARGB(255, 1, 30, 56)
                            : const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.upload,
                              color: type == 'expense'
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : const Color.fromARGB(255, 1, 30, 56),
                            ),
                            onPressed: () {
                              setState(() {
                                type = 'expense';
                                showExpenseText = true;
                                showSavingText = false;
                              });
                            },
                          ),
                          if (showExpenseText)
                            const Text(
                              'รายจ่าย',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(15),
          //   child: PieChart(
          //     PieChartData(
          //       sections: [
          //         PieChartSectionData(
          //           color: Colors.blue,
          //           value: 40,
          //           title: '40%',
          //           radius: 50,
          //           titleStyle: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //         PieChartSectionData(
          //           color: Colors.red,
          //           value: 30,
          //           title: '30%',
          //           radius: 50,
          //           titleStyle: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //         PieChartSectionData(
          //           color: Colors.green,
          //           value: 20,
          //           title: '20%',
          //           radius: 50,
          //           titleStyle: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //         PieChartSectionData(
          //           color: Colors.yellow,
          //           value: 10,
          //           title: '10%',
          //           radius: 50,
          //           titleStyle: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 1, 30, 56),
              child: StreamBuilder<List<Transaction>>(
                stream:
                    firebaseService.getTransactions(), // Get all transactions
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }

                  // If data is available, filter it based on the selected type and month
                  final transactions = snapshot.data!;
                  filteredTransactions = transactions.where((transaction) {
                    // Parse the date correctly based on the expected format (dd/MM/yyyy)
                    DateTime transactionDate =
                        DateFormat('dd/MM/yyyy').parse(transaction.date);
                    return transaction.type == type &&
                        transactionDate.month == selectedDate.month &&
                        transactionDate.year ==
                            selectedDate.year; // Filter based on type and month
                  }).toList();

                  // Group transactions by category and summarize amounts
                  Map<String, double> summaryMap = {};
                  for (var transaction in filteredTransactions!) {
                    summaryMap.update(transaction.category,
                        (existingAmount) => existingAmount + transaction.amount,
                        ifAbsent: () => transaction.amount);
                  }

                  return ListView.builder(
                    itemCount: summaryMap.length,
                    itemBuilder: (context, index) {
                      // Get the category and total amount for the current group
                      String category = summaryMap.keys.elementAt(index);
                      double totalAmount = summaryMap[category]!;

                      return ListTile(
                        title: Text(
                          category,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          '\$${totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: type == 'saving' ? Colors.green : Colors.red,
                          ),
                        ),
                        onTap: () {
                          // Filter transactions by the selected category
                          List<Transaction> categoryTransactions =
                              filteredTransactions!
                                  .where((transaction) =>
                                      transaction.category == category)
                                  .toList();

                          // Show a dialog with the transactions for the selected category
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(category),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true, // Prevent overflow
                                    itemCount: categoryTransactions.length,
                                    itemBuilder: (context, index) {
                                      final transaction =
                                          categoryTransactions[index];
                                      return ListTile(
                                        title: Text(
                                          transaction.description,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        subtitle: Text(
                                          '${transaction.category} - ${transaction.date}',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        trailing: Text(
                                          '\$${transaction.amount.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: transaction.type == 'saving'
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
