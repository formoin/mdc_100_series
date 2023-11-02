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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shrine/home.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();


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
                final userCredential = await signInWithGoogle();
                if (userCredential != null) {
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
                final userCredential = await signInAnonymously();
                if (userCredential != null) {
                  print("Hi");
                  Navigator.popUntil(context,ModalRoute.withName("/"));
                  // Navigator.pushNamed(context, '/home');
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
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn(); // 여기서 에러 뜬다는 말이야?
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    // Google 로그인 인증 정보를 사용하여 Firebase에 인증
    final AuthCredential credential = GoogleAuthProvider.credential( // 다시 돌려서 어디서 막히는 지 봐줘
      accessToken: googleSignInAuthentication.accessToken, 
      idToken: googleSignInAuthentication.idToken,
    );

    // Firebase에 로그인
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    
    return userCredential;
  } catch (error) {
    print('Google 로그인 실패: $error'); // 여기? 프린트 된다고? 너무 에러 체킹을 넓게 한다
    return null;
  }
}

void signOutGoogle() async {
  await _googleSignIn.signOut();
  print("Google 사용자 로그아웃");
}