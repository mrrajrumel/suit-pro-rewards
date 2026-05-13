import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final String role;
  final String? phone;
  final String tier;
  final int points;
  final double totalSpent;
  final String? suitproId;
  final String? referralCode;
  final String? referredBy;
  final String? suitSize;
  final String? shirtSize;
  final String? trouserSize;

  AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    this.phone,
    this.tier = 'Silver',
    this.points = 0,
    this.totalSpent = 0,
    this.suitproId,
    this.referralCode,
    this.referredBy,
    this.suitSize,
    this.shirtSize,
    this.trouserSize,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data, String documentId) {
    return AppUser(
      uid: documentId,
      fullName: data['full_name'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
      role: data['role'] ?? 'user',
      phone: data['phone'],
      tier: data['tier'] ?? 'Silver',
      points: data['points_balance'] ?? data['points'] ?? 0,
      totalSpent: (data['total_spent'] ?? 0).toDouble(),
      suitproId: data['suitpro_id'],
      referralCode: data['referral_code'],
      referredBy: data['referred_by'],
      suitSize: data['suit_size'],
      shirtSize: data['shirt_size'],
      trouserSize: data['trouser_size'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'full_name': fullName,
      'email': email,
      'role': role,
      'phone': phone,
      'tier': tier,
      'points_balance': points,
      'total_spent': totalSpent,
      'suitpro_id': suitproId,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'suit_size': suitSize,
      'shirt_size': shirtSize,
      'trouser_size': trouserSize,
    };
  }
}
