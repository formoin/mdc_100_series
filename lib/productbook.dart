import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './model/product.dart';



class ProductBook extends StatefulWidget {
  const ProductBook({
    super.key, 
    required this.addMessage, 
    required this.deleteMessage,
    required this.products,
  });

  final FutureOr<void> Function(String name, int price, String discription) addMessage;
  final FutureOr<void> Function(Product messagedoc) deleteMessage;
  final List<Product> products;

  @override
  State<ProductBook> createState() => _ProductBookState();
}

class _ProductBookState extends State<ProductBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        const SizedBox(height: 8),
        for (var message in widget.products)
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${message.name}: ${message.price}\n${message.discription}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                if (FirebaseAuth.instance.currentUser!.displayName == message.name) ...[
                  IconButton(
                    onPressed: () => widget.deleteMessage(message), 
                    icon: Icon(Icons.delete_outline))
                ],
              ],
            )),
      ],
    );
  }
}