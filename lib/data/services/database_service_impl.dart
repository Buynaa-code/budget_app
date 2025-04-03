import 'package:budget_app/core/services/database_service.dart';
import 'package:budget_app/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseServiceImpl implements DatabaseService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DatabaseServiceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  String get uid => _auth.currentUser?.uid ?? '';

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get transactions: $e');
    }
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toMap());
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toMap());
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }
}
