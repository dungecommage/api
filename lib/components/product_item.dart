

import 'package:flutter/material.dart';

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
              child: Image.network(item['image']['url'])
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