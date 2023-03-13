import 'package:flutter/material.dart';

import '../../components/product_item.dart';
import '../../theme.dart';

Widget productRelated(BuildContext context, dynamic item) {
  var relatedPr = item['related_products'];
  if(relatedPr.isEmpty) {
    return Container();
  } 
  else {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Related product',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorTheme
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: relatedPr.map<Widget>((option) => Container(
              width: 200,
              margin: EdgeInsets.only(right: 20),
              child: productBox(
                context,
                option
              ),
            )).toList(),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Divider(
              thickness: 10,
            ),
          ),
        ),
      ],
    );
  }
}