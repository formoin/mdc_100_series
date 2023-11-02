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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/app_state.dart';
import 'package:shrine/detailed.dart';
import 'package:shrine/productbook.dart';

import 'model/product.dart';
import 'model/products_repository.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://www.handong.edu/');
List<Product> favorite = [];
List<String> list = <String>['ASC', 'DESC'];


class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}



class _HomePage extends State<HomePage> {
List<Product> products = [];

  List<Card> _buildGridCards(BuildContext context) {
    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container(
              height: 100,
              padding: EdgeInsets.zero,
              child: PhotoHero(
                photo: 'https://picsum.photos/250?image=9',
                // package: product.assetPackage,
                width: 300,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Row(
                    //   children: 
                    //     // List.generate(product.isFeatured, (index) {
                    //     //   return const Icon(
                    //     //     Icons.star,
                    //     //     color: Colors.yellow,
                    //     //     size: 15,
                    //     //   );
                    //     // })         
                    // ),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                        ),
                        Text(
                          product.price.toString(),
                          style: const TextStyle(
                            fontSize: 12,

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
          icon: Icon(
            Icons.person,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/mypage');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.plus_one,
              semanticLabel: 'search',
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
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Expanded(
              child: ProductBook(
                      addMessage: (name, price, discription) =>
                          appState.addProduct(name, price, discription),
                      products: appState.products,
                      deleteMessage: (productdoc) =>
                          appState.deleteProduct(productdoc),
                    ),
            
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget _buildList() {
    return OrientationBuilder(
      builder:(context, orientation) {
        return GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: _buildGridCards(context),
      );
      },
    );
      
  }
  
}



class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.photo,
    // required this.package,
    this.onTap,
    required this.width,
  });

  final String photo;
  // final String package;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onDoubleTap: onTap,
            child: Image.network(
              photo,
            ),
          ),
        ),
      ),
    );
  }
}


