import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTransaction(Transaction transaction) async {
    DocumentReference docRef =
        await _db.collection('transactions').add(transaction.toMap());
    await docRef.update({'id': docRef.id});
  }

  Stream<List<Transaction>> getTransactions() {
    return _db.collection('transactions').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => Transaction.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Future<bool> deleteTransaction(Transaction transaction) async {
    try {
      await _db.collection('transactions').doc(transaction.id).delete();
      print("Deleted transaction with ID: ${transaction.id} completed");
      return true; 
    } catch (e) {
      print("Error deleting transaction: $e");
      return false; 
    }
  }
}

class Transaction {
  String? id;
  String type; // 'saving' or 'expense'
  double amount;
  String description;
  String date;
  String category;

  Transaction({
    this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'date': date,
      'category': category,
    };
  }

  Transaction.fromFirestore(
      Map<String, dynamic> firestoreData, String documentId)
      : id = firestoreData['id'],
        type = firestoreData['type'],
        amount = firestoreData['amount'],
        description = firestoreData['description'],
        date = firestoreData['date'],
        category = firestoreData['category'];
}
