import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTransaction(Transaction transaction) async {
    await _db.collection('transactions').add(transaction.toMap());
  }

  Stream<List<Transaction>> getTransactions(String month) {
    return _db
        .collection('transactions')
        .where('month', isEqualTo: month)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transaction.fromFirestore(doc.data()))
            .toList());
  }
}

class Transaction {
  String? id;
  String? month;
  String type; // 'saving' or 'expense'
  double amount;
  String description;

  Transaction({
    this.id,
    this.month,
    required this.type,
    required this.amount,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'type': type,
      'amount': amount,
      'description': description,
    };
  }

  Transaction.fromFirestore(Map<String, dynamic> firestoreData)
      : id = firestoreData['id'],
        month = firestoreData['month'],
        type = firestoreData['type'],
        amount = firestoreData['amount'],
        description = firestoreData['description'];
}


