import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/add_expense/add_expense.dart';
import 'package:project/pages/main_screen.dart';
import 'menu_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home Page'),
      //   actions: [
      //     IconButton(
      //       onPressed: signOut,
      //       icon: const Icon(Icons.logout),
      //     ),
      //   ],
      // ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          backgroundColor: Colors.white,
          elevation: 3,
          currentIndex: index,
          selectedItemColor: const Color.fromARGB(255, 8, 117, 254),
          unselectedItemColor: Colors.grey,
          selectedIconTheme:
              const IconThemeData(color: Color.fromARGB(255, 8, 117, 254)),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          selectedLabelStyle: const TextStyle(
              color: Color.fromARGB(255, 8, 117, 254),
              fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(color: Colors.grey),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
              ),
              label: 'หน้าแรก',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'ตัวฉัน',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          alignment: AlignmentDirectional.bottomCenter,
          padding: const EdgeInsets.only(bottom: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return AddTransactionScreen();
                      });
                },
                backgroundColor: const Color.fromARGB(255, 8, 117, 254),
                child: const Icon(Icons.edit_note),
              ),
              const SizedBox(height: 4), // Space between button and text
              const Text(
                'จดโน้ต',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          )),
      body: index == 0 ? TransactionListScreen(month: DateTime.now().month.toString()) : const MenuScreen(),
    );
  }
}
