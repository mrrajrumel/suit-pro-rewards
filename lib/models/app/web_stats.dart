class WebStats {
  final int totalOrders;
  final int totalSpent;

  WebStats({required this.totalOrders, required this.totalSpent});

  factory WebStats.fromJson(Map<String, dynamic> json) {
    return WebStats(
      totalOrders: json['total_orders'],
      totalSpent: json['total_spent'],
    );
  }
}
