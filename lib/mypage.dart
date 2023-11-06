import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shrine/model/product.dart';
import 'login.dart';
import 'home.dart';


class MyhomePage extends StatefulWidget{
  const MyhomePage({Key? key}) : super(key: key);

  @override
  State<MyhomePage> createState() => _MyhomePage();
}

class _MyhomePage extends State<MyhomePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              loginver == 1 ? signInWithGoogle() : signOutAnonymously();
              Navigator.pushNamed( context, '/login' );
            },
            icon: Icon(
              Icons.exit_to_app,
            ))
        ]
      ),
      body: SingleChildScrollView(
        child: Column(
          // Set background to blue to emphasize that it's a new route.
          children: [
            if(loginver == 2) ...[
              Container(
                padding: EdgeInsets.zero,
                alignment: Alignment.topCenter,
                child: 
                  Image.network(
                  width:200,
                  height:200,
                  'http://handong.edu/site/handong/res/img/logo.png'
                ) 
              ),
            ]
            else ...[
              Container(
                padding: EdgeInsets.zero,
                alignment: Alignment.topCenter,
                child: 
                  Image.network(
                  width:200,
                  height:200,
                  imageurl!
                ) 
              ),
            ],
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children : [
                        SizedBox(
                         width: 240,
                          child: Text(
                  // ********************** user ID
                           userid!,
                           textAlign: TextAlign.left,
                           style: const TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 30,
                           ),
                                                  ),
                        ), 
                        SizedBox(width: 50,),
                        Divider( thickness: 1,),
                        SizedBox(width: 5),
                        if(loginver == 2) ... [
                          Text(
                            'anonymous',
                            style: TextStyle(
                              fontSize: 20,
                            )
                          ),
                        ]
                        else ... [
                          Text(
                            email!,
                            style: TextStyle(
                              fontSize: 20,
                            )
                          ),
                        ],
                        SizedBox(height: 20),
                        Divider(thickness: 1, height: 1, color: Colors.black),
                        SizedBox(height: 100),
                        SizedBox(
                          width: 250,
                          child: Text(
                            "Minkyeong Kim\n\nI promise to take the test honestly before GOD ."
                          ),
                        ),
                        SizedBox(height: 100,),
                        
                  
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
