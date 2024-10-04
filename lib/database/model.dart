import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTransaction(Transaction transaction) async {
    await _db.collection('transactions').add(transaction.toMap());
  }

  Stream<List<Transaction>> getTransactions() {
    return _db
        .collection('transactions')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transaction.fromFirestore(doc.data()))
            .toList());
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

  // Method to convert Transaction object to a map for Firestore
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

  // Factory constructor to create a Transaction from Firestore data
  Transaction.fromFirestore(Map<String, dynamic> firestoreData)
      : id = firestoreData['id'],
        type = firestoreData['type'],
        amount = firestoreData['amount'],
        description = firestoreData['description'],
        date = firestoreData['date'],
        category = firestoreData['category'];
}
