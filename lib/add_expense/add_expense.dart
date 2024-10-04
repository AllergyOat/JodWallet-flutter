import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  
  String selectedCategory = 'Food';
  DateTime selectDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
        backgroundColor: const Color.fromARGB(255, 250, 212, 79),
      ),
      backgroundColor: const Color.fromARGB(255, 1, 30, 56),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // type section
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

            // amount section
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              textAlignVertical:
                  TextAlignVertical.center, // Align text vertically
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    const Color.fromARGB(255, 1, 22, 41), // Background color
                prefixIcon: const Icon(
                  Icons.upload_sharp,
                  color: Color.fromARGB(255, 231, 67, 49),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                label: const Text(
                  "Amount",
                  style: TextStyle(color: Colors.white),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 45),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 8),

            // calendar section
            TextFormField(
              controller: dateController,
              style: const TextStyle(color: Colors.white),
              textAlignVertical: TextAlignVertical.center,
              readOnly: true,
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: selectDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (newDate != null) {
                  dateController.text =
                      DateFormat('dd/MM/yyyy').format(newDate);
                  selectDate = newDate;
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 1, 22, 41),
                prefixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Color.fromARGB(255, 49, 143, 231),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 30),
              ),
            ),
            const SizedBox(height: 8),

            // category section
            TextFormField(
              textAlignVertical: TextAlignVertical.center,
              readOnly: true,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Food'),
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Food';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Transport'),
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Transport';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Shopping'),
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Shopping';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Entertainment'),
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Entertainment';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Health'),
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Health';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Education'),
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Education';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Other'),
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Other';
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 1, 22, 41),
                prefixIcon: const Icon(
                  Icons.list,
                  color: Color.fromARGB(255, 49, 143, 231),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                label: const Text(
                  "เลือกหมวดหมู่",
                  style: TextStyle(color: Colors.white),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 30),
              ),
            ),
            const SizedBox(height: 8),

            // description section
            TextFormField(
              controller: descriptionController,
              style: const TextStyle(
                  color: Colors.white), // Set text color to white
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    const Color.fromARGB(255, 1, 22, 41), // Background color
                prefixIcon: const Icon(
                  Icons
                      .note, // You can change the icon to something related to notes
                  color: Color.fromARGB(255, 49, 143, 231),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                labelText: "เพิ่มโน้ต",
                labelStyle: const TextStyle(color: Colors.white),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: const EdgeInsets.symmetric(vertical: 30),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double amount = double.parse(amountController.text);
                String description = descriptionController.text;

                Transaction newTransaction = Transaction(
                  id: UniqueKey().toString(), // Generate a unique id
                  type: type,
                  amount: amount,
                  description: description,
                  date: dateController.text,
                  category: selectedCategory,
                );

                firebaseService.addTransaction(newTransaction);
                Navigator.pop(context); // Return to previous screen
              },
              child: const Text("Add Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
