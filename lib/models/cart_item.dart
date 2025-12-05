class CartItem {
  final String id;
  final String name;
  final double price;
  final String color;
  final String size;
  final int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    required this.size,
    required this.quantity,
    required this.imageUrl,
  });

  double get total => price * quantity;

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    String? color,
    String? size,
    int? quantity,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      color: color ?? this.color,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
