

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../pages/product.dart';
import '../theme.dart';
import '../utils.dart';

Widget productBox(
    BuildContext context, 
    dynamic item,
  ) => Container(
    decoration: BoxDecoration(
      color: colorWhite,
      boxShadow: [
        BoxShadow(
          color: colorBlack.withOpacity(0.1),
          blurRadius: 10,
            offset: Offset(0,0),
        ),
      ],
      borderRadius: BorderRadius.circular(11)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(
                sku: item['sku'],
              ),
            ),
          ),
          child: Container(
            width: context.w * 0.5 - 30,
            height: context.w * 0.5 - 30,
            // margin: EdgeInsets.only(bottom: 10),
            child: FittedBox(
              child: Image.network(
                item['image']['url'],
                errorBuilder:
                  (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const Text('Image not found');
              },
              )
            )
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item['name']}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 7,),
              Visibility(
                visible: (item['price_range']['minimum_price']['discount']['percent_off'] == 0)? false : true,
                child: Text(
                  currencyWithPrice(
                    item['price_range']['minimum_price']['regular_price'],
                  ),
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: colorGrey1
                  ),
                ),
              ),
              Visibility(
                visible: (item['price_range']['minimum_price']['discount']['percent_off'] == 0)? false : true,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: colorTheme,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    "${item['price_range']['minimum_price']['discount']['percent_off']}%",
                    style: TextStyle(
                      color: colorWhite
                    ),
                  ),
                ),
              ),
              Text(
                currencyWithPrice(
                  item['price_range']['minimum_price']['final_price'],
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
Widget productTypeList(
    BuildContext context, 
    dynamic item,
  ) => Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: colorWhite,
      boxShadow: [
        BoxShadow(
          color: colorBlack.withOpacity(0.1),
          blurRadius: 10,
            offset: Offset(0,0),
        ),
      ],
      borderRadius: BorderRadius.circular(11)
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(
                sku: item['sku'],
              ),
            ),
          ),
          child: Container(
            width: 120,
            height: 120,
            // margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(right: 10),
            child: FittedBox(
              child: Image.network(
                item['image']['url'],
                errorBuilder:
                  (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const Text('Image not found');
              },
              )
            )
          ),
        ),
        Container(
          width: context.w - 160,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item['name']}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 7,),
              Visibility(
                visible: (item['price_range']['minimum_price']['discount']['percent_off'] == 0)? false : true,
                child: Text(
                  currencyWithPrice(
                    item['price_range']['minimum_price']['regular_price'],
                  ),
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: colorGrey1
                  ),
                ),
              ),
              Visibility(
                visible: (item['price_range']['minimum_price']['discount']['percent_off'] == 0)? false : true,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: colorTheme,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    "${item['price_range']['minimum_price']['discount']['percent_off']}%",
                    style: TextStyle(
                      color: colorWhite
                    ),
                  ),
                ),
              ),
              Text(
                currencyWithPrice(
                  item['price_range']['minimum_price']['final_price'],
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              Html(
                data: item['short_description']['html'],
                style: {
                  'body': Style(
                    // padding: EdgeInsets.zero,
                    margin: Margins(
                      bottom: Margin.zero(),
                      left: Margin.zero(),
                      top: Margin.zero(),
                      right: Margin.zero(),
                    ),
                  ),
                },
              )
            ],
          ),
        ),
      ],
    ),
  );