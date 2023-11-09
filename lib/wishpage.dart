import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/app_state.dart';
import 'package:shrine/login.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/model/wishlist.dart';

Future<void> deleteWish(Wishlist product) async{
    await product.reference.delete();
}

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);
  @override
  
  State<WishlistPage> createState() => _WishlistPage();
}
class _WishlistPage extends State<WishlistPage>  {
  List<Product> wishproduct = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wish List'),
      ),
      body: SingleChildScrollView(
        child: Consumer<ApplicationState>(
        builder: (context,appstate, _) {
          return Column(
            children: [
              for(Wishlist wishlist in appstate.wishlist)
                Row(children: [
                  Container(
                    height: 100,
                    padding: EdgeInsets.zero,
                    child: Image.network(
                      wishlist.image,
                      width: 200,
                      height: 50,
                    ),
                  ),
                  Container(
                    width: 150,
                    alignment: Alignment.center,
                    child: Text(
                      wishlist.name
                    ),
                  ),
                  IconButton(
                    onPressed: () => deleteWish(wishlist), 
                    icon: Icon(Icons.delete)
                  )
                ]),
              
            ],
          );
          
        }
      ),
        
      ),
      
      
    );
  }
  
}


