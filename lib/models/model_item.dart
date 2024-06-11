import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  late String title;
//  late String description;
  late String brand;
  late String imageUrl;
  late String price;
  late String registerDate;
  late int keyNumber;
  late int faceType;
  late String id;


  Item({
    required this.title,
//    required this.description,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.registerDate,
    required this.keyNumber,
    required this.faceType,
    required this.id,
  });

  Item.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    title = data['title'];
//    description = data['description'];
    brand = data['brand'];
    imageUrl = data['imageUrl'];
    price = data['price'];
    registerDate = data['registerDate'];
    keyNumber = data['keyNumber'];
    faceType = data['faceType'];
  }

  Item.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
//    description = data['description'];
    brand = data['brand'];
    imageUrl = data['imageUrl'];
    price = data['price'];
    registerDate = data['registerDate'];
    keyNumber = data['keyNumber'];
    keyNumber = data['faceType'];
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': id,
      'title': title,
//      'description': description,
      'brand': brand,
      'imageUrl': imageUrl,
      'price': price,
      'registerDate': registerDate,
      'keyNumber': keyNumber,
      'faceType': faceType,
    };
  }
}