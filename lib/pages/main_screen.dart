import 'package:flutter/material.dart';
import 'package:project/pages/transactionDetail.dart';
import '../database/model.dart';
import 'package:intl/intl.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  FirebaseService firebaseService = FirebaseService();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateTime selectedMonth = DateTime.now(); // Track selected month

  Color getDateColor(String date) {
    DateTime parsedDate = dateFormat.parse(date);
    if (parsedDate.day == DateTime.now().day &&
        parsedDate.month == DateTime.now().month &&
        parsedDate.year == DateTime.now().year) {
      return const Color.fromARGB(203, 255, 235, 59); // Highlight color
    } else {
      return Colors.white; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 30, 56),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 212, 79),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Color.fromARGB(255, 49, 143, 231),
                size: 30.0,
              ),
              onPressed: () {
                setState(() {
                  selectedMonth =
                      DateTime(selectedMonth.year, selectedMonth.month - 1);
                });
              },
            ),
            const SizedBox(width: 8),
            if (selectedMonth.month == DateTime.now().month &&
                selectedMonth.year == DateTime.now().year)
              const Icon(
                Icons.calendar_month,
                color: Color.fromARGB(255, 49, 143, 231),
                size: 20,
              ),
            const SizedBox(width: 8),
            Text(
              DateFormat('MMMM yy').format(selectedMonth),
              style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 49, 143, 231),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_right,
                color: Color.fromARGB(255, 49, 143, 231),
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  selectedMonth =
                      DateTime(selectedMonth.year, selectedMonth.month + 1);
                });
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Transaction>>(
        stream: firebaseService.getTransactions(), // Get all transactions
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Transaction> transactions = snapshot.data as List<Transaction>;

          // Filter transactions to show only for the selected month
          transactions = transactions.where((transaction) {
            DateTime transactionDate = dateFormat.parse(transaction.date);
            return transactionDate.year == selectedMonth.year &&
                transactionDate.month == selectedMonth.month;
          }).toList();

          // Sort transactions by date in descending order (newest first)
          transactions.sort((a, b) {
            DateTime dateA = dateFormat.parse(a.date);
            DateTime dateB = dateFormat.parse(b.date);
            return dateB.compareTo(dateA);
          });

          // Group transactions by date
          Map<String, List<Transaction>> groupedTransactions = {};
          for (var transaction in transactions) {
            String date = transaction.date; // Use date as key
            if (!groupedTransactions.containsKey(date)) {
              groupedTransactions[date] = [];
            }
            groupedTransactions[date]!.add(transaction);
          }

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/empty_box.png', // Path to your image
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'คุณยังไม่ได้ทำรายการในเดือนนี้',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ListView.builder(
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                String date = groupedTransactions.keys.elementAt(index);
                List<Transaction> dailyTransactions =
                    groupedTransactions[date]!;

                // Calculate total income and outcome for the day
                double totalIncome = 0;
                double totalOutcome = 0;
                for (var transaction in dailyTransactions) {
                  if (transaction.type == 'saving') {
                    totalIncome += transaction.amount;
                  } else {
                    totalOutcome += transaction.amount;
                  }
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Align children vertically in the center
                          children: [
                            // Container for date with left border
                            Container(
                              height: 60, // Set height
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: getDateColor(date),
                                    width: 3.5,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 4.0, bottom: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'วันที่ : ',
                                          style: TextStyle(
                                            color: getDateColor(date),
                                          ),
                                        ), // Text before the date
                                        TextSpan(
                                          text: DateFormat('d')
                                              .format(dateFormat.parse(date)),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            color: getDateColor(date),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Expanded(child: SizedBox()),

                            // The container part for income and outcome
                            Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 24, 51, 75),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center content vertically
                                crossAxisAlignment: CrossAxisAlignment
                                    .end, // Align text to the right
                                children: [
                                  Center(
                                    // Center the total income text
                                    child: Text(
                                      'Total Income: \$${totalIncome.toStringAsFixed(2)}',
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  Center(
                                    // Center the total outcome text
                                    child: Text(
                                      'Total Outcome: \$${totalOutcome.toStringAsFixed(2)}',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
                      // Display the transactions for the day
                      Column(
                        children: dailyTransactions.map((transaction) {
                          return ListTile(
                            title: Center(
                              child: Text(
                                transaction.description,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      '${transaction.type} - \$${transaction.amount}'),
                                  Text(
                                    'Category: ${transaction.category}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            textColor: transaction.type == 'saving'
                                ? Colors.green
                                : Colors.red,
                            onTap: () {
                              print('Transaction ID: ${transaction.id}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetailScreen(
                                      transaction: transaction,
                                      firebaseService: firebaseService),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
