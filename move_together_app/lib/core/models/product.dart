class Product {
  final String title;
  final String description;
  final String imageUrl;

  Product({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      description: json['description'],
      imageUrl: json['thumbnail'],
    );
  }
}
