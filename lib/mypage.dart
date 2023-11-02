import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shrine/detailed.dart';
import 'package:shrine/model/product.dart';

import 'home.dart';

class MyhomePage extends StatefulWidget{
  const MyhomePage({Key? key}) : super(key: key);

  @override
  State<MyhomePage> createState() => _MyhomePage();
}

class _MyhomePage extends State<MyhomePage>{
  Widget _buildCardfavorite(BuildContext context, int index) {

    Product _favorite = favorite[index];

    return Card(
      // =
    );
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Page'),),
      body: Column(
          children: [
            // Load a Lottie file from a remote url
            ClipOval(
              child: Lottie.network(
                fit: BoxFit.contain,
                'https://assets7.lottiefiles.com/packages/lf20_dwGMPRJ7zu.json'),
            ),
            const SizedBox(height: 20,),
            Row(
              children: const [
                SizedBox(width: 120,),
                Text(
                  'MinKyeong Kim',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                SizedBox(width: 160,),
                Text(
                  '21800071',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            const Text(
              '  My Favorite Hotel List',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Expanded(
              child: _buildListfavorite()
            ),
            
          ],
        ),
    );
  }
  Widget _buildListfavorite(){
    return ListView.builder(
        itemCount: favorite.length,
        itemBuilder: (context, index) {
          return Container(
            //padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            constraints: const BoxConstraints(maxHeight: 200, maxWidth: 200),
            child: _buildCardfavorite(context, index),
          );
        },
    );
  }

}
