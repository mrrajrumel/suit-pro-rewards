class Activity {
  final String id;
  final String description;
  final DateTime createdAt;

  Activity({required this.id, required this.description, required this.createdAt});

  factory Activity.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Activity(
      id: documentId,
      description: data['description'] ?? '',
      createdAt: (data['created_at'] as dynamic).toDate(),
    );
  }
}
