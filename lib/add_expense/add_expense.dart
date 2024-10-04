import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/database/model.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String type = 'saving';
  bool showSavingText = true;
  bool showExpenseText = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();

  String selectedCategory = '';
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
        backgroundColor: const Color.fromARGB(255, 250, 212, 79),
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarHeight: 65,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 60,
                decoration: BoxDecoration(
                  color: type == 'saving'
                      ? const Color.fromARGB(255, 1, 30, 56)
                      : const Color.fromARGB(255, 252, 231, 141),
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(8)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.download,
                        color: type == 'saving' ? Colors.white : Colors.black,
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
                      : const Color.fromARGB(255, 252, 231, 141),
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(8)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.upload,
                        color: type == 'expense' ? Colors.white : Colors.black,
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
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 1, 30, 56),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 40, left: 25, right: 25, bottom: 20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                " เพิ่มรายการ",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            // amount section
            TextFormField(
              controller: amountController,
              style: const TextStyle(color: Colors.white, fontSize: 25),
              keyboardType: TextInputType.number,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 1, 22, 41),
                prefixIcon: Icon(
                  showSavingText ? Icons.download : Icons.upload,
                  color: showSavingText
                      ? const Color.fromARGB(255, 0, 128, 0) // Green color
                      : const Color.fromARGB(255, 255, 0, 0), // Red color
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                label: const Text(
                  "ระบุจำนวน ฿‎",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25,
                  ),
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
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dialogTheme: DialogTheme(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
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
              controller: TextEditingController(text: selectedCategory),
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(color: Colors.white),
              readOnly: true,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
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
                labelText: "เลือกหมวดหมู่",
                labelStyle: const TextStyle(color: Colors.grey),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: const EdgeInsets.symmetric(vertical: 30),
              ),
            ),
            const SizedBox(height: 8),

            // description section
            TextFormField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    const Color.fromARGB(255, 1, 22, 41), // Background color
                prefixIcon: const Icon(
                  Icons.note_alt_outlined,
                  color: Color.fromARGB(255, 49, 143, 231),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                labelText: "เพิ่มโน้ต",
                labelStyle: const TextStyle(color: Colors.grey),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: const EdgeInsets.symmetric(vertical: 30),
              ),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 49, 143, 231),
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: () {
                double amount = double.parse(amountController.text);
                String description = descriptionController.text;

                Transaction newTransaction = Transaction(
                  id: UniqueKey().toString(),
                  type: type,
                  amount: amount,
                  description: description,
                  date: dateController.text,
                  category: selectedCategory,
                );

                firebaseService.addTransaction(newTransaction);
                Navigator.pop(context);
              },
              child: Text(
                "Add Transaction",
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
