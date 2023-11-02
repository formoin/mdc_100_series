import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shrine/model/product.dart';
import 'home.dart';

class SecondScreenArguments {
  Product product;

  SecondScreenArguments({required this.product});
}

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.photo,
    required this.package,
    this.onTap,
    this.wid,
    required this.width,
  });

  final String photo;
  final String package;
  final VoidCallback? onTap;
  final Widget? wid;
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
            child: Image.asset(
              photo,
              package: package,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
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
      ),
      body: SingleChildScrollView(
        child: Column(
          // Set background to blue to emphasize that it's a new route.
          children: [
//             Stack(
//               alignment: Alignment.topRight,
//               children : [
//                 Container(
//                   padding: EdgeInsets.zero,
//                   alignment: Alignment.topCenter,
//                   child: PhotoHero(
//                     photo: args.product.assetName,
//                     package: args.product.assetPackage,
//                     width: 400.0,
//                     onTap: () {
//                       setState(() {
//                         //  = !args.product.isFavorite;
//                         if(favorite.contains(args.product)){
//                           args.product.isFavorite = false;
//                           favorite.remove(args.product);
//                         }
//                         else{
//                           args.product.isFavorite = true;
//                           favorite.add(args.product);
//                         }
                        
//                       });
//                     },
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   child: (args.product.isFavorite
//                     ? const Icon(
//                       Icons.favorite,
//                       size: 30,
//                       color: Colors.red,
//                     )
//                     : const Icon(
//                       Icons.favorite,
//                       size: 30,
//                       color: Colors.black38,
//                     )
//                   ),
                  
//                 ),
                
//               ],
              
//             ),
        
//             Container(
//               padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children : [
              
//                   Row(
//                     children: List.generate(args.product.isFeatured, (index) {
//                       return const Icon(
//                         Icons.star,
//                         color: Colors.yellow,
//                         size: 20,
//                       );
//                     })
//                   ),
//                   const SizedBox(height: 10),
//                   AnimatedTextKit(
//                     animatedTexts: [
//                       TypewriterAnimatedText(
//                       args.product.name,
//                       textAlign: TextAlign.left,
//                         textStyle: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Color.fromARGB(255, 21, 93, 152),
//                         ),
//                         speed: const Duration(milliseconds: 200),
//                       ),
//                     ],
//                     totalRepeatCount: 4,
//                     pause: const Duration(milliseconds: 1000),
//                     displayFullTextOnTap: true,
//                     stopPauseOnTap: true,
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         color: Colors.blue,
//                       ),
//                       const SizedBox(width: 5),
//                       Text(args.product.address),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.phone,
//                         color: Colors.blue,
//                       ),
//                       const SizedBox(width: 5),
//                       Text(args.product.phonenum),
      
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   const Divider(thickness: 1, height: 1, color: Colors.black26),
//                   const SizedBox(height: 20),
//                   Text(
//                     args.product.descrip,
//                   ),
//                 ],
//               ),
//             ),
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

