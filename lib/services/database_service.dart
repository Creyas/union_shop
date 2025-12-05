import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ SAVE USER DATA
  Future<void> createUser(String userId, String name, String email) async {
    await _db.collection("users").doc(userId).set({
      "name": name,
      "email": email,
      "createdAt": Timestamp.now(),
    });
  }

  // ✅ ADD ITEM TO CART
  Future<void> addToCart(String userId, Map<String, dynamic> item) async {
    await _db
        .collection("cart")
        .doc(userId)
        .collection("items")
        .doc(item["id"])
        .set(item);
  }

  // ✅ GET CART ITEMS
  Future<List<Map<String, dynamic>>> getCart(String userId) async {
    final snapshot = await _db
        .collection("cart")
        .doc(userId)
        .collection("items")
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // ✅ PLACE ORDER
  Future<void> placeOrder(
    String userId,
    List<Map<String, dynamic>> cartItems,
    double total,
  ) async {
    await _db.collection("orders").add({
      "userId": userId,
      "items": cartItems,
      "total": total,
      "status": "processing",
      "createdAt": Timestamp.now(),
    });
  }

  // ✅ GET USER ORDERS
  Future<List<Map<String, dynamic>>> getOrders(String userId) async {
    final snapshot = await _db
        .collection("orders")
        .where("userId", isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}