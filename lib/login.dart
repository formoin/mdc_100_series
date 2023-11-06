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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shrine/home.dart';

int? loginver;
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
String? userid;
String? email;
String? username;
String? imageurl;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                const SizedBox(height: 16.0),
                const Text('SHRINE'),
              ],
            ),
            const SizedBox(height: 120.0),
            ElevatedButton(
              child: const Text('Google 로그인'),
              onPressed: () async {
                // Google 로그인 시도
                loginver =1;
                final userCredential = await signInWithGoogle();
                if (userCredential != null) {
                  saveGoogleUserToFirestore(userCredential.user!);
                  Navigator.popUntil(context,ModalRoute.withName("/"));
                } else {
                  print("Error! Cannot login with google");
                  Exception();
                }
              },
            ),
            ElevatedButton(
              child: const Text('익명 로그인'),
              onPressed: () async {
                // 익명 로그인 시도
                loginver=2;
                final userCredential = await signInAnonymously();
                if (userCredential != null) {
                  final user = userCredential.user;
                  saveAnonymousUserToFirestore(user!);
                  Navigator.popUntil(context,ModalRoute.withName("/"));
                } else {
                  print("Error! Cannot login anonymously");
                  Exception();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


Future<UserCredential?> signInAnonymously() async {
  try {
    final UserCredential userCredential = await _auth.signInAnonymously();
    return userCredential;
  } catch (error) {
    print('익명 로그인 실패: $error');
    return null;
  }
}

Future<UserCredential?> signInWithGoogle() async {
  try {
    // Google 로그인 인증 플로우 시작
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    // Google 로그인 인증 정보를 사용하여 Firebase에 인증
    final AuthCredential credential = GoogleAuthProvider.credential( 
      accessToken: googleSignInAuthentication.accessToken, 
      idToken: googleSignInAuthentication.idToken,
    );

    // Firebase에 로그인
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    
    return userCredential;
  } catch (error) {
    print('Google 로그인 실패: $error'); 
    return null;
  }
}

Future<void> saveAnonymousUserToFirestore(User user) async {
  userid = user.uid;
  FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set(<String, dynamic>{
    'message': "I promise to take the test honestly before GOD.",
    'uid': FirebaseAuth.instance.currentUser!.uid,
  });

}

// user가 이미 userdb에 있다면 초기화 및 db 저장x
// user가 없다면 초기화된 정보 db에 저장


// user의 정보 불러와서 변수에 저장 -> 이거 안해도 되는듯? 할 만한게 없는데? 그냥 로그인하면 auth에서 다 관리 가능

Future<void> saveGoogleUserToFirestore(User user) async {
  
  for (final providerProfile in user.providerData) { 

    userid = providerProfile.uid;
    email = providerProfile.email;
    username = providerProfile.displayName;
    imageurl = 'https://image.musinsa.com/mfile_s01/2022/05/16/c7544ec00472f1860347a0094c0ecfa1181418.jpg';

    FirebaseFirestore.instance
        .collection('user')
        .doc(providerProfile.uid)
        .set(<String, dynamic>{
      'message': "I promise to take the test honestly before GOD.",
      'uid': providerProfile.uid,
      'name': providerProfile.displayName,
      'email': providerProfile.email
    });
      
  }

}

void signOutGoogle() async {
  await _googleSignIn.signOut();
  print("Google 사용자 로그아웃");
}

void signOutAnonymously() async {
  print("signout anonymously");
  await FirebaseAuth.instance.signOut();
  
}