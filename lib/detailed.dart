import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shrine/model/product.dart';
import 'home.dart';

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
    timeDilation = 5.0; // 1.0 means normal animation speed.

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
            }, icon: Icon(
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
                          SizedBox(width: 50,),
                          IconButton(
                            onPressed: (() => ''), 
                            icon: Icon(
                              size: 35,
                              Icons.thumb_up
                          )),
                          
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
    );
  }
  
}

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: (_isFavorited
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border)),
            color: Colors.yellow[500],
            onPressed: _toggleFavorite,
          ),
        ),
        
      ],
    );
  }
}

