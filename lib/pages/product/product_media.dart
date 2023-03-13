import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme.dart';

class ProductMedia extends StatefulWidget {
  dynamic item;
  ProductMedia({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  State<ProductMedia> createState() => _ProductMediaState();
}

class _ProductMediaState extends State<ProductMedia> {
  @override
  Widget build(BuildContext context) {
    String mainImage = widget.item['image']['url'];
    var galleryList = widget.item['media_gallery'];
    var gallerySize = galleryList.length;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          height: context.h * 0.5,
          child: Align(
            alignment: Alignment.center,
            child: Image.network(mainImage)
          )
        ),
        Visibility(
          visible: (gallerySize > 1)? true : false,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: galleryList.map<Widget>((media) =>
                 InkWell(
                  onTap: (){
                    setState(() {
                      mainImage = media['url'];
                      print(media['url']);
                      print(mainImage);
                    });
                  },
                   child: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorGreyBorder),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    width: 80,
                    height: 80,
                    child: FittedBox(
                      child: Image.network(media['url'])
                    ),
                  ),
                 )).toList()
              ),
            ),
          ),
        ),
      ],
    );
  }
}