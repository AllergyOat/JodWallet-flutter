import 'package:flutter/material.dart';
import 'package:project/database/model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String type = 'saving';
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: type,
              items: ['saving', 'expense'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  type = newValue!;
                });
              },
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Amount"),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double amount = double.parse(amountController.text);
                String description = descriptionController.text;
                String month = DateTime.now().month.toString(); // Get current month

                Transaction newTransaction = Transaction(
                  id: UniqueKey().toString(), // Generate a unique id
                  month: month,
                  type: type,
                  amount: amount,
                  description: description,
                );

                firebaseService.addTransaction(newTransaction);
                Navigator.pop(context); // Return to previous screen
              },
              child: Text("Add Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
