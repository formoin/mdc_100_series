import 'dart:async';    
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';


import 'firebase_options.dart';
import './model/product.dart';   

enum Like { yes, no, unknown }

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
    
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  int _likecount = 0;
  int get likecount => _likecount;

  var db = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _productSubscription;
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> init() async {
    
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);
    

     

    FirebaseAuth.instance.userChanges().listen((user) {
      
      _loggedIn = true;
      _productSubscription = FirebaseFirestore.instance
          .collection('productbook')
          .orderBy('price')
          .snapshots()
          .listen((snapshot) {
        _products = [];
        for (final document in snapshot.docs) {
          _products.add(
            Product(
              uid: document.data()['userId'] as String,
              name: document.data()['name'] as String,
              image: document.data()['image'] as String,
              price: document.data()['price'],
              discription: document.data()['description'] as String,
              created: document.data()['timestamp'] == null? null : DateTime.fromMicrosecondsSinceEpoch(document.data()['timestamp'].microsecondsSinceEpoch).toLocal(),
              modified: document.data()['modified'] == null? null : DateTime.fromMillisecondsSinceEpoch(document.data()['modified'].millisecondsSinceEpoch).toLocal(),
              reference: document.reference,
              liker: List<String>.from(document.data()['liker'] as List),
            ),
          );
        }
        notifyListeners();
      });
        
      notifyListeners();
    });
    
  }
    
}