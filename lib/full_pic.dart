import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../main.dart';

class FullPhoto extends StatelessWidget {
  final String url;

  const FullPhoto({ Key? key,required this.url }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isWhite ? Colors.white:Colors.black,
      appBar: AppBar(
        toolbarHeight: 90,
              backgroundColor: isWhite?Colors.white:Colors.grey[900],
                iconTheme: IconThemeData(color: Colors.red),
                title:Text('Image',style:TextStyle(color: Colors.red,fontWeight: FontWeight.bold)),
                centerTitle: true,

      ),
      body: Container(
        child: PhotoView(imageProvider: NetworkImage(url),

        ),
      ),
    );
  }
}