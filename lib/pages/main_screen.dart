import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/detail/transactionDetail.dart';
import '../database/model.dart';
import 'package:intl/intl.dart';
import '../detail/transactionResult.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  TransactionListScreenState createState() => TransactionListScreenState();
}

class TransactionListScreenState extends State<TransactionListScreen> {
  FirebaseService firebaseService = FirebaseService();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateTime selectedMonth = DateTime.now();

  Color getDateColor(String date) {
    DateTime parsedDate = dateFormat.parse(date);
    if (parsedDate.day == DateTime.now().day &&
        parsedDate.month == DateTime.now().month &&
        parsedDate.year == DateTime.now().year) {
      return const Color.fromARGB(203, 255, 235, 59);
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 30, 56),
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(100), // Adjust height for added content
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 250, 212, 79),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
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
                        selectedMonth = DateTime(
                            selectedMonth.year, selectedMonth.month - 1);
                      });
                    },
                  ),
                  const SizedBox(width: 5),
                  if (selectedMonth.month == DateTime.now().month &&
                      selectedMonth.year == DateTime.now().year)
                    const Icon(
                      Icons.calendar_month,
                      color: Color.fromARGB(255, 8, 117, 254),
                      size: 20,
                    ),
                  const SizedBox(width: 5),
                  Text(
                    DateFormat('MMMM yy').format(selectedMonth),
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 8, 117, 254),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: Color.fromARGB(255, 8, 117, 254),
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedMonth = DateTime(
                            selectedMonth.year, selectedMonth.month + 1);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'สวัสดีวัยรุ่น! (ชื่อผู้ใช้)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => TransactionResultScreen(),
                        ),
                      );
                      },
                      style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 8, 117, 254),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                      ),
                      ),
                      child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.running_with_errors_outlined,
                          color: Colors.white),
                        SizedBox(width: 8),
                        Text('ดูสรุป'),
                      ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: StreamBuilder<List<Transaction>>(
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
                      'assets/img/empty_box.png',
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
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
                                            text: 'วันที่ ',
                                            style: TextStyle(
                                              color: getDateColor(date),
                                            ),
                                          ),
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
                                width: MediaQuery.of(context).size.width * 0.77,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 24, 51, 75),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Income section (รายรับ)
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.arrow_downward,
                                                color: Color.fromARGB(
                                                    255, 111, 130, 148),
                                                size: 20,
                                              ),
                                              const SizedBox(width: 4),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Container(
                                              width: 1,
                                              height: 40,
                                              color: const Color.fromARGB(
                                                  255, 111, 130, 148),
                                            ),
                                          ),
                                          // Outcome section (รายจ่าย)
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.arrow_upward,
                                                color: Color.fromARGB(
                                                    255, 111, 130, 148),
                                                size: 20,
                                              ),
                                              const SizedBox(width: 4),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Display the transactions for the day
                        Row(
                          children: [
                            // Spacer to push the content to the right
                            Expanded(flex: 23, child: Container()),

                            // Container to hold the transactions, 77% width of the screen
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.77,
                                child: Column(
                                  children:
                                      dailyTransactions.map((transaction) {
                                    return ListTile(
                                      tileColor:
                                          const Color.fromARGB(255, 1, 23, 40),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.category,
                                            color: Color.fromARGB(
                                                255, 111, 130, 148),
                                            size: 25,
                                          ),
                                          const SizedBox(width: 7),
                                          Expanded(
                                            child: Text(
                                              transaction.category,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '+${transaction.amount}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  transaction.type == 'saving'
                                                      ? Colors.green
                                                      : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 33.0),
                                              child: Text(
                                                transaction.description,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionDetailScreen(
                                              transaction: transaction,
                                              firebaseService: firebaseService,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
