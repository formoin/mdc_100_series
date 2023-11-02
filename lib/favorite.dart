import 'package:flutter/material.dart';


import 'home.dart';


class FavoritePage extends StatefulWidget{
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Hotels'),),
      body: ListView.builder(
        itemCount: favorite.length,
        itemBuilder:(context, index) {
          final _favorite = favorite[index];
          return Dismissible (
            // key: Key(_favorite.name),
            key: UniqueKey(),
            onDismissed: (direction){
              setState(() {
                favorite.remove(favorite[index]);
              });
            },
            background: Container(color: Colors.red),
            child: Container (
              padding: const EdgeInsets.fromLTRB(28.0, 10.0, 20, 0.0),
              child:ListTile(
                
                title: Text(
                  _favorite.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          );
        },

      ),
    );
  }

}
