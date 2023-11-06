import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shrine/model/product.dart';
import 'home.dart';
import 'detailed.dart';


class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);
  @override
  
  State<UpdatePage> createState() => _UpdatePage();
}
class _UpdatePage extends State<UpdatePage>  {
  
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

  Future<String> saveImage(Product product) async {
    Future<String> url;
    if (_image != null) {
      // 이미지가 선택된 경우 Firebase Storage에 업로드
      Reference storageReference = FirebaseStorage.instance.ref().child("product/${_image!.path.toString}");
      await storageReference.putFile(_image!);
      url = storageReference.getDownloadURL();
      print('Image uploaded to Firebase Storage.');
    } else {
      Reference storageReference = FirebaseStorage.instance.ref().child("product/${FirebaseAuth.instance.currentUser!.uid}");
      await storageReference.putString(product.image);
      url = Future(() => product.image);
      print('Saving default image as product image.');
    }
    return url;
  }

  Future<void> editDataToFirestore(Product product) async {
    String productName = product.name;
    int productPrice = product.price;
    String discription = product.discription;

    Future<String> url = saveImage(product);
    String _url = await url;

    FirebaseFirestore.instance
        .collection('productbook')
        .doc(product.reference.id)
        .update(<String, dynamic>{
      'image': _url,
      'name': productName,
      'price': productPrice,
      'description': discription,
      'timestamp': Timestamp.fromDate(product.created!),
      'modified': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'liker':product.liker,
    });

    // 저장 후 원하는 동작을 수행할 수 있습니다.
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SecondScreenArguments;
    timeDilation = 5.0; // 1.0 means normal animation speed.
    Product product = args.product;
    final _nameController = TextEditingController(text: product.name);
    final _priceController = TextEditingController(text: product.price.toString());
    final _descriptionController = TextEditingController(text: product.discription);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
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
              product.name = _nameController.text;
              product.price = int.parse(_priceController.text);
              product.discription = _descriptionController.text;

              editDataToFirestore(product);    
              Navigator.pushNamed(
                context, 
                '/'
              );           
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: _image == null
                  ? Image.network(product.image)
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
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your message to continue';
                        }
                        
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your message to continue';
                        }
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your message to continue';
                        }
                      },
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

