import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme.dart';

Widget productInfo(BuildContext context, dynamic item){
  var myCount = int.parse('${item['review_count']}');
  assert(myCount is int);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: context.w,
        margin: EdgeInsets.only(top: 10, bottom: 5),
        child: Text(
          '${item['name']}',
          style: TextStyle(
            fontSize: 20
          ),
        )
      ),
      Wrap(
        children: [
          Text(
            'Mã sản phẩm:',
            style: TextStyle(
              color: colorGrey1
            ),
          ),
          Text(
            '${item['sku']}',
          )
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 15),
        child: Wrap(
          spacing: 7,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 105,
                  child: Row(
                    children: List<Widget>.generate(5, (int index) {
                      return Container(
                        margin: EdgeInsets.only(right: 3),
                        child: Icon(
                          FontAwesomeIcons.solidStar,
                          size: 18,
                          color: colorGrey1,
                        ),
                      );
                    }),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topLeft,
                      widthFactor: item['rating_summary'] / 100,
                      child: Row(
                        children: List<Widget>.generate(5, (int index) {
                          return Container(
                            margin: EdgeInsets.only(right: 3),
                            child: Icon(
                              FontAwesomeIcons.solidStar,
                              size: 18,
                              color: colorYellow,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                )
              ]
            ),
            Text('${item['review_count']}'),
            Text(
              (myCount > 1)? 'reviews' : 'review'
            ),
            
          ],
        ),
      ),
    ],
  );
}