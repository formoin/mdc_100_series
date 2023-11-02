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

  int _attendees = 0;
  int get attendees => _attendees;

  StreamSubscription<QuerySnapshot>? _productSubscription;
  StreamSubscription<QuerySnapshot>? _userSubscription;
  List<Product> _products = [];
  List<Product> get products => _products;

  Like _like = Like.unknown;
  StreamSubscription<DocumentSnapshot>? _attendingSubscription;
  Like get like => _like;
  set like(Like like) {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    if (like == Like.yes) {
      userDoc.set(<String, dynamic>{'like': true});
    } else {
      userDoc.set(<String, dynamic>{'like': false});
    }
  }
  
  Future<void> init() async {
    
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);
    

    //  FirebaseFirestore.instance
    //     .collection('attendees')
    //     .where('attending', isEqualTo: true)
    //     .snapshots()
    //     .listen((snapshot) {
    //   _attendees = snapshot.docs.length;
    //   notifyListeners();
    // });

    // FirebaseAuth.instance.userChanges().listen((user) {
    //   if (user != null) {
    //     _loggedIn = true;
    //     _productSubscription = FirebaseFirestore.instance
    //         .collection('product')
    //         .orderBy('timestamp', descending: true)
    //         .snapshots()
    //         .listen((snapshot) {
    //       _products = [];
    //       for (final document in snapshot.docs) {
    //         _products.add(
    //           Product(
    //             name: document.data()['name'] as String,
    //             // imageURL: ' ',
    //             price: document.data()['price'],
    //             descrip: document.data()['description'] as String,
    //             created: DateTime.fromMillisecondsSinceEpoch(int.parse(document.data()['timestamp'].toString())),
    //             // modified: DateTime.fromMillisecondsSinceEpoch(int.parse(document.data()['modified'].toString())),
    //             // reference: document.reference
    //             // likeNum: 
    //           ),
    //         );
    //       }
        //   notifyListeners();
        // });
        // _attendingSubscription = FirebaseFirestore.instance
        //     .collection('attendees')
        //     .doc(user.uid)
        //     .snapshots()
        //     .listen((snapshot) {
        //   if (snapshot.data() != null) {
        //     if (snapshot.data()!['attending'] as bool) {
        //       _attending = Attending.yes;
        //     } else {
        //       _attending = Attending.no;
        //     }
        //   } else {
        //     _attending = Attending.unknown;
  //         }
  //         notifyListeners();
  //       });
  //     } else {
  //       _loggedIn = false;
  //       _guestBookMessages = [];
  //       _productSubscription?.cancel();
  //       _attendingSubscription?.cancel();
  //     }
  //     notifyListeners();
  //   });
  }
  
  Future<DocumentReference> addProduct(String name, int price, String descrip) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('guestbook')
        .add(<String, dynamic>{
      'name': name,
      'price': price,
      'description': descrip,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      // 'name': FirebaseAuth.instance.currentUser!.displayName,
      // 'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> deleteProduct(Product product) async{

    await product.reference.delete();
  }
}