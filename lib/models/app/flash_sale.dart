class FlashSale {
  final String id;
  final String name;
  final String url;
  final int discountPercentage;

  FlashSale({
    required this.id,
    required this.name,
    required this.url,
    required this.discountPercentage,
  });

  factory FlashSale.fromJson(Map<String, dynamic> json) {
    return FlashSale(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      discountPercentage: json['discount_percentage'],
    );
  }
}
