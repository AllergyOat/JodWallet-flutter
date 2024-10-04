import 'package:flutter/material.dart';
import '../database/model.dart';

class TransactionListScreen extends StatelessWidget {
  TransactionListScreen({Key? key}) : super(key: key);

  FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 30, 56),
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

          return Center(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                Transaction transaction = transactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Center(
                      child: Text(
                        transaction.description,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${transaction.type} - \$${transaction.amount}'),
                          Text(
                            'Date: ${transaction.date}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
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
