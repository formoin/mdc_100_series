import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/app_state.dart';
import 'package:shrine/login.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/model/wishlist.dart';
import 'package:shrine/wishpage.dart';

List<String> liker = [];
List<Product> ispressed = [];

class SecondScreenArguments {
  Product product;

  SecondScreenArguments({required this.product});
}

Future<void> deleteProduct(Product product) async{

    await product.reference.delete();
}

class DetailedPage extends StatefulWidget {
  const DetailedPage({Key? key}) : super(key: key);
  @override
  
  State<DetailedPage> createState() => _DetailedPage();
}
class _DetailedPage extends State<DetailedPage>  {

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SecondScreenArguments;
    liker = args.product.liker;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          if (FirebaseAuth.instance.currentUser!.uid == args.product.uid) ...[
            
            IconButton(onPressed: (){
              Navigator.pushNamed(
                context, 
                '/update', 
                arguments: SecondScreenArguments(product: args.product));
            }, icon: const Icon(
              Icons.create
            )),
            IconButton(
              onPressed: () {
                deleteProduct(args.product);
                Navigator.pushNamed(context, '/' );
              } ,
              icon: Icon(Icons.delete)),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // Set background to blue to emphasize that it's a new route.
          children: [
            Container(
              padding: EdgeInsets.zero,
              alignment: Alignment.topCenter,
              child: Image.network(
                width:400,
                height:300,
                args.product.image
              )
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                           SizedBox(
                            width: 240,
                             child: Text(
                              args.product.name,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Color.fromARGB(255, 21, 93, 152),
                              ),
                                                     ),
                           ), 
                          SizedBox(width: 45,),
                          IconButton(
                            onPressed: (() {
                              if(args.product.liker.contains(userid)){
                                final snackBar = SnackBar(
                                  content: Text('You can only do it once!!'
                                ),);
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                              else{
                                liker.add(userid!);
                                FirebaseFirestore.instance
                                  .collection('productbook')
                                  .doc(args.product.reference.id)
                                  .update({"liker":liker});
                                final snackBar = SnackBar(
                                   content: Text('I LIKE IT!!'),
                                  
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }), 
                            icon: Icon(
                              size: 35,
                              Icons.thumb_up
                          )),
                          Consumer<ApplicationState>(
                            builder: (context, appState, _ ) => Text(
                              args.product.liker.length.toString()
                            ),
                          
                          ),
                          
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            args.product.price.toString(),
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.blue,
                            )
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(thickness: 1, height: 1, color: Colors.black),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 350,
                        child: Text(
                          args.product.discription,
                        ),
                      ),
                      SizedBox(height: 100,),
                      Text('Creator : '+args.product.uid),
                      Text(
                        args.product.created.toString()+'(created)'
                      ),
                      Text(
                        args.product.modified.toString()+'(modified)'
                      ),

                    ],
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<ApplicationState>(
        builder: (context,appstate, _) => FloatingActionButton(
            onPressed: () => {
              appstate.wish(args.product),
            },
            child: appstate.wishname.contains(args.product.name) ? Icon(Icons.check) : Icon(Icons.shopping_cart)
        ),
      ),
      
      
      
    );
  }
  
}


