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

import 'package:flutter/material.dart';
import 'package:shrine/add.dart';
import 'package:shrine/mypage.dart';
import 'package:shrine/signup.dart';
import 'package:shrine/update.dart';
import 'package:shrine/wishpage.dart';

import 'home.dart';
import 'login.dart';
import 'favorite.dart';
import 'search.dart';
import 'detailed.dart';

// TODO: Convert ShrineApp to stateful widget (104)
class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/': (BuildContext context) => const HomePage(),
        '/add':( BuildContext context) => const AddPage(),
        '/update':( BuildContext context) => const UpdatePage(),  
        '/search': (BuildContext context) => const SearchPage(),
        '/detailed': (BuildContext context) => const DetailedPage(),
        '/wishpage': (BuildContext context) => const WishlistPage(),
        '/mypage' : (BuildContext context) => const MyhomePage(),
      },

      theme: ThemeData.light(useMaterial3: true),
    );
  }
}

// TODO: Build a Shrine Theme (103)
// TODO: Build a Shrine Text Theme (103)
