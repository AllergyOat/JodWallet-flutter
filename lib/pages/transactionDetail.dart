import 'package:flutter/material.dart';
import '../database/model.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;
  final FirebaseService firebaseService;

  TransactionDetailScreen(
      {Key? key, required this.transaction, required this.firebaseService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: const Color.fromARGB(255, 1, 30, 56),
      ),
      backgroundColor: const Color.fromARGB(255, 1, 30, 56),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Description: ${transaction.description}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Amount: \$${transaction.amount}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Type: ${transaction.type}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Category: ${transaction.category}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${transaction.date}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (transaction.id != null) {
                    print(
                        'Deleting transaction with ID: ${transaction.id}'); // Debugging line
                    bool success =
                        await firebaseService.deleteTransaction(transaction);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Transaction deleted successfully.')),
                      );
                      Navigator.pop(context); // Go back after deletion
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to delete transaction.')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Transaction ID is missing.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: const Text('Delete Transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
