class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final String role;
  final String? suitproId;
  final int points;

  AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    this.suitproId,
    this.points = 0,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data, String documentId) {
    return AppUser(
      uid: documentId,
      fullName: data['full_name'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
      role: data['role'] ?? 'user',
      suitproId: data['suitpro_id'],
      points: data['points'] ?? 0,
    );
  }
}
