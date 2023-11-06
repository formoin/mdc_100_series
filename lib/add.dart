import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrine/detailed.dart';
import 'package:shrine/model/product.dart';
import 'home.dart';
import 'productbook.dart';
import 'app_state.dart';



class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);
  @override
  
  
  State<AddPage> createState() => _AddPage();
}


class _AddPage extends State<AddPage>  {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  late Product inputProduct;

  File? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  // final ProductBook productBook = ProductBook(addMessage: ApplicationState addProduct, deleteMessage: deleteMessage, products: products);

  //이미지를 가져오는 함수
  void getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> saveImage() async {
    Future<String> url;
    if (_image != null) {
      // 이미지가 선택된 경우 Firebase Storage에 업로드
      Reference storageReference = FirebaseStorage.instance.ref().child("product/${_image!.absolute}");
      await storageReference.putFile(_image!);
      url = storageReference.getDownloadURL();
      print('Image uploaded to Firebase Storage.');
    } else {
      Reference storageReference = FirebaseStorage.instance.ref().child("product/${FirebaseAuth.instance.currentUser!.uid}");
      await storageReference.putString("https://handong.edu/site/handong/res/img/logo.png");
      url = Future(() => "https://handong.edu/site/handong/res/img/logo.png");
      print('Saving default image as product image.');
    }
    return url;
  }

  Future<void> saveDataToFirestore() async {
    String productName = _nameController.text;
    int productPrice = int.parse(_priceController.text);
    String discription = _descriptionController.text;
    Future<String> url = saveImage();
    String _url = await url;

    FirebaseFirestore.instance
        .collection('productbook')
        .add(<String, dynamic>{
      'image': _url,
      'name': productName,
      'price': productPrice,
      'description': discription,
      'timestamp': FieldValue.serverTimestamp(),
      'modified': null,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'liker': liker,
    });

    // 저장 후 원하는 동작을 수행할 수 있습니다.
  }
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
        leadingWidth: 80,
        leading: TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.black38,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
            onPressed: () async{
              // 상품이 저장 되어야 함        
              saveDataToFirestore();
              _descriptionController.clear();
              _nameController.clear();
              _priceController.clear(); 
              
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // image picker
            Container(
              height: 260,
              child: _image == null
                ? Image.network("https://handong.edu/site/handong/res/img/logo.png")
                : Image.file(
                    File(_image!.path),
                    height: 200,
                  ),
            ),
            const SizedBox(height: 20),
            IconButton(
              onPressed: getImage,
              icon: const Icon(
                Icons.camera
              ),
            ),
            const SizedBox(height: 20),
            // 정보 입력받는 textformfields
            Expanded(
              child: Container(
                width: 300,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      
                      decoration: const InputDecoration(
                        hintText: 'Product Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your message to continue';
                        }
                        inputProduct.name = _nameController.text;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      // initialValue: 'Product Name',
                      decoration: const InputDecoration(
                        hintText: 'Price',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your message to continue';
                        }
                        inputProduct.price = int.parse(_priceController.text);
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      // initialValue: 'Product Name',
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your message to continue';
                        }
                        inputProduct.discription = _descriptionController.text;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
  }
  
}


