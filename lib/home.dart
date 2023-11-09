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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/app_state.dart';
import 'package:shrine/detailed.dart';

import 'model/product.dart';
import 'app_state.dart';
import 'add.dart';
import 'detailed.dart';


List<Product> favorite = [];
List<String> list = <String>['ASC', 'DESC'];

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}



class _HomePage extends State<HomePage> {
  List<Product> productslist = [];

  List<Card> _buildGridCards(BuildContext context, ApplicationState appState, String dropdownValue) {
    dropdownValue == 'ASC' ? productslist = appState.products : productslist = List.from(appState.products.reversed);
    
    if (productslist.isEmpty) {
      return const <Card>[];
    }
    return productslist.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Consumer<ApplicationState>(
                  builder: (context, appstate, _) =>Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 100,
                  padding: EdgeInsets.zero,
                  child: Image.network(
                    product.image,
                    width: 300,
                    height: 400,
                  ),
                ),
                if(appstate.wishname.contains(product.name) )...[
                  const Icon(Icons.check_circle),
                ]
                
              ]
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                          size: 12,
                        ),
                        Expanded(
                          child: Text(
                            product.price.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                                            
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.zero,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        
                        onPressed: () {
                          Navigator.pushNamed(
                            context, 
                            '/detailed', 
                            arguments: SecondScreenArguments(product: product));
                       },
                        child: const Text(
                          'more',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      );
    }).toList();
  }



  bool vertical = false;
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Main'),
        leading: IconButton(
          icon: const Icon(
            Icons.person,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/mypage');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/wishpage');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(20),
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 10, width: 1000
          ),
          Expanded(    
             child: _buildList(context, dropdownValue)  
          ),
          
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildList(BuildContext context, String dropdownValue) {
    return Consumer<ApplicationState>(
      builder:(context, appState, _) {
        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: _buildGridCards(context, appState, dropdownValue),
        );
      },
    );   
  }
  
}
