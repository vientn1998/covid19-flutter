import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewPager extends StatefulWidget {

  String url;
  ImageViewPager({this.url, this.fileImage});
  File fileImage;
  @override
  _ImageViewPagerState createState() => _ImageViewPagerState();
}

class _ImageViewPagerState extends State<ImageViewPager> {



  @override
  Widget build(BuildContext context) {
    print('ImageViewPager file ${widget.fileImage.path} \n length: ${widget.fileImage.lengthSync()}');
    return Scaffold(
//      body: Container(
//        child: PhotoView(
//          imageProvider: FileImage(widget.fileImage, scale: 1),
//        ),
//      ),
    body: Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
          image: FileImage(widget.fileImage, scale: 1),
          fit: BoxFit.cover,
        ),
      ),
    ),
    );
  }
}
