import 'package:flutter/material.dart';
import 'package:shrine/model/product.dart';

class AddWishlist extends ChangeNotifier{
  final List<Product> _wishlist = [];

  List<Product> get wishlist => _wishlist;

  void addwishlist(Product wish) {
    _wishlist.add(wish) ;
    notifyListeners();

  }

}