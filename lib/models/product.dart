class Product {
  int id;
  String name;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['product'] ?? "",
      price: json['price'] ?? 0.0,
    );
  }

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}
