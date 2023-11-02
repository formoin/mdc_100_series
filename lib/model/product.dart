// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloud_firestore/cloud_firestore.dart';

//URL, name, price, favorite_num = 0, discription = default, UID, createtime, recentupdatetime,
class Product {
  Product({
    required this.uid,
    required this.image,
    required this.name, 
    required this.price,
    required this.discription, 
    required this.created,
    // required this.modified, 
    required this.reference,
    // required this.likeNum
  });

  final String uid;
  final String image;
  String name;
  int price;
  String discription;
  DateTime created;
  // final DateTime modified;
  final DocumentReference reference; 
  // final int likeNum;
  

  // String get assetName => '$uid-0.jpg';
  // String get assetPackage => 'shrine_images';

  // @override
  // String toString() => "$name (id=$uid)";
}

