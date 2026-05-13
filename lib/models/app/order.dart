class Order {
  final int id;
  final String status;
  final String placedAt; // Using String for simplicity, can be converted to DateTime
  final String total;

  Order({
    required this.id,
    required this.status,
    required this.placedAt,
    required this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status']?['name'] ?? 'Unknown',
      placedAt: json['created_at'] ?? 'No Date',
      total: json['total']?['text'] ?? '£0.00',
    );
  }
}
