import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaterService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('User is not signed in.');
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _usage =>
      _db.collection('users').doc(_uid).collection('water_usage');

  Future<void> addUsage(double litres, String activity) async {
    await _usage.add({
      'litres': litres,
      'activity': activity,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> recentUsage() {
    return _usage.orderBy('createdAt', descending: true).limit(10).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  Stream<double> todayTotal() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return _usage
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('createdAt', isLessThan: Timestamp.fromDate(end))
        .snapshots()
        .map((snapshot) => snapshot.docs.fold<double>(
              0, (sum, doc) => sum + ((doc.data()['litres'] as num?)?.toDouble() ?? 0),
            ));
  }
}
