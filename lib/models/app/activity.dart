import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String description;
  final DateTime? createdAt;
  final int points;
  final String type; // earn, spend, referral, bonus

  Activity({
    required this.id,
    required this.description,
    this.createdAt,
    this.points = 0,
    this.type = 'earn',
  });

  factory Activity.fromFirestore(Map<String, dynamic> data, String documentId) {
    DateTime? dt;
    if (data['created_at'] != null) {
      if (data['created_at'] is Timestamp) {
        dt = (data['created_at'] as Timestamp).toDate();
      } else if (data['created_at'] is String) {
        dt = DateTime.tryParse(data['created_at']);
      }
    }

    return Activity(
      id: documentId,
      description: data['description'] ?? '',
      createdAt: dt,
      points: data['points'] ?? 0,
      type: data['type'] ?? 'earn',
    );
  }
}
