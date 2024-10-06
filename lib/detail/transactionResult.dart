import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../database/model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class TransactionResultScreen extends StatefulWidget {
  const TransactionResultScreen({super.key});

  @override
  _TransactionResultScreenState createState() =>
      _TransactionResultScreenState();
}

class _TransactionResultScreenState extends State<TransactionResultScreen> {
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
            'สรุปรายรับ-รายจ่าย',
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
            const SizedBox(width: 10),
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
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'เดือน',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM yyyy').format(selectedDate),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                          size: 20,
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
                    DateTime transactionDate =
                        DateFormat('dd/MM/yyyy').parse(transaction.date);
                    return transaction.type == type &&
                        transactionDate.month == selectedDate.month &&
                        transactionDate.year == selectedDate.year;
                  }).toList();

                  // Group transactions by category and summarize amounts
                  Map<String, double> summaryMap = {};
                  double totalIncome = 0;
                  double totalOutcome = 0;

                  for (var transaction in filteredTransactions!) {
                    summaryMap.update(transaction.category,
                        (existingAmount) => existingAmount + transaction.amount,
                        ifAbsent: () => transaction.amount);

                    if (transaction.type == 'saving') {
                      totalIncome += transaction.amount;
                    } else {
                      totalOutcome += transaction.amount;
                    }
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Text(
                            type == 'saving'
                                ? 'รายรับสุทธิ : ${totalIncome.toInt()} บาท'
                                : 'รายจ่ายสุทธิ : ${totalOutcome.toInt()} บาท',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: PieChart(
                          PieChartData(
                            sections: summaryMap.entries.map((entry) {
                              double percentage = (entry.value /
                                      (type == 'saving'
                                          ? totalIncome
                                          : totalOutcome)) *
                                  100;
                              return PieChartSectionData(
                                value: entry.value,
                                color: Color((Random().nextDouble() * 0xFFFFFF)
                                        .toInt())
                                    .withOpacity(1.0),
                                title: '${percentage.toStringAsFixed(1)}%',
                                titleStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: summaryMap.length,
                          itemBuilder: (context, index) {
                            String category = summaryMap.keys.elementAt(index);
                            double totalAmount = summaryMap[category]!;

                            return Container(
                              color: const Color.fromARGB(255, 1, 23, 40),
                              child: ListTile(
                                title: Text(
                                  category,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: Text(
                                  '${totalAmount.toInt()} ฿',
                                  style: TextStyle(
                                    color: type == 'saving'
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                                onTap: () {
                                  List<Transaction> categoryTransactions =
                                      filteredTransactions!
                                          .where((transaction) =>
                                              transaction.category == category)
                                          .toList();

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor:
                                            Color.fromARGB(255, 24, 51, 75),
                                        title: Text(
                                          category,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        content: SizedBox(
                                          width: double.maxFinite,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                categoryTransactions.length,
                                            itemBuilder: (context, index) {
                                              final transaction =
                                                  categoryTransactions[index];
                                              return ListTile(
                                                title: Text(
                                                  '${transaction.category} - ${transaction.date}',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                subtitle: Text(
                                                  transaction.description,
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                trailing: Text(
                                                  '\$${transaction.amount.toInt()}',
                                                  style: TextStyle(
                                                    color: transaction.type ==
                                                            'saving'
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
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
                                            child: const Text('Close',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
