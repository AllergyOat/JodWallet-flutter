import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 30, 56),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 250, 212, 79),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ขอบคุณที่ใช้งานแอปพลิเคชั่นของเรา!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'กรุณาเลือกเมนูที่ต้องการ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                Image.asset(
                  'assets/img/rich_man.png',
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'คำถามที่พบบ่อย',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    title: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 1, 23, 40),
                      ),
                      child: Text(
                        'ทำไมต้องลงชื่อเข้าใช้',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'เมื่อเครื่องหายหรือลบแอปพลิเคชั่นแล้วกลับมาใช้งาน ข้อมูลที่บันทึกไว้จะยังคงอยู่ ทำให้สามารถใช้งานได้โดยไม่ต้องเป็นกังวล',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    title: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 1, 23, 40),
                      ),
                      child: Text(
                        'หากเจอบัคในระบบต้องทำอย่างไร',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'ทำใจยอมรับมัน เราควรปล่อยวางต่อบัคทั้งหลายทั้งปวง',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    title: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 1, 23, 40),
                      ),
                      child: Text(
                        'แอปนี้จะมีการพัฒนาต่อไปหรือไม่',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'เนื่องด้วยทางทีมพัฒนาของเรามีงานถาโถมเข้ามามากมาย ทำให้ไม่สามารถพัฒนาต่อไปได้แต่หากทางเรามีเวลาแล้ว เราจะรีบนำเวลานั้นไปใช้ในการนอนหลับทันที',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    title: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 1, 23, 40),
                      ),
                      child: Text(
                        'ติดต่อได้ช่องทางไหนบ้าง',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'gmail: aphichat.peanroop@gmail.com',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'ล๊อกเอาท์',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text(
                                  'คุณแน่ใจหรือไม่ที่ต้องการออกจากระบบ'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('ยกเลิก'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    signOut();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Logout',
                                      style: TextStyle(
                                        color: Colors.red,
                                      )),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.87,
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 1, 23, 40),
                        ),
                        child: Text(
                          'ออกจากระบบ',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
