import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
  final String id;
  final String title;
  final String description;
  final String code;
  final DateTime expiresAt;
  final String qrData;

  Voucher({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.expiresAt,
    required this.qrData,
  });

  factory Voucher.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Voucher(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      code: data['code'] ?? 'NOCODE',
      expiresAt: (data['expires_at'] as Timestamp).toDate(),
      qrData: data['qr_data'] ?? doc.id, // Fallback to using the document ID for the QR code
    );
  }
}
