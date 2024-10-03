import 'package:flutter/material.dart';
import '../database/model.dart';

class TransactionListScreen extends StatelessWidget {
  final String month;

  TransactionListScreen({required this.month});

  FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions for $month")),
      backgroundColor: const Color.fromARGB(255, 1, 30, 56),
      body: StreamBuilder<List<Transaction>>(
        stream: firebaseService.getTransactions(month),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Transaction> transactions = snapshot.data as List<Transaction>;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              Transaction transaction = transactions[index];
              return ListTile(
                title: Text(transaction.description),
                subtitle: Text('${transaction.type} - \$${transaction.amount}'),
                textColor: transaction.type == 'saving'
                    ? Colors.green
                    : Colors.red,
              );
            },
          );
        },
      ),
    );
  }
}
