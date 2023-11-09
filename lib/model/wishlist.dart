import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shrine/model/product.dart';

//URL, name, price, favorite_num = 0, discription = default, UID, createtime, recentupdatetime,
class Wishlist {
  Wishlist({
    required this.name ,
    required this.image,
    required this.reference,
  });


  String name;
  String image;
  final DocumentReference reference;
  
}