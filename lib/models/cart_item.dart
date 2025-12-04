class CartItem {
  final String id;
  final String name;
  final double price;
  final String color;
  final String size;
  int quantity;
  final String? imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    required this.size,
    required this.quantity,
    this.imageUrl,
  });

  double get total => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      color: color,
      size: size,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl,
    );
  }
}
