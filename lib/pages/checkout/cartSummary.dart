import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphql/query.dart';
import '../../theme.dart';
import '../../utils.dart';
import '../checkout.dart';

Widget summaryOrder(BuildContext context, dynamic prices, dynamic discounts, List isShipping){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Order Total: ${currencyWithPrice(prices['grand_total'])}',
        style: PrimaryFont.bold(16),
      ),
      checkShippingAdd(context, isShipping),
      SizedBox(height: 3,),
      Text(
        'Sub Total: ${currencyWithPrice(prices['subtotal_excluding_tax'])}',
      ),
      SizedBox(height: 3,),
      discountCart(context, discounts),
    ],
  );
}

Widget checkShippingAdd(BuildContext context, List isShipping){
  if(isShipping != null){
    dynamic selectedShipping = isShipping[0]['selected_shipping_method'];
    return Text('Shipping: ${currencyWithPrice(selectedShipping['amount'])}');
  } else{
    return Container();
  }
}

Widget discountCart(BuildContext context, dynamic discounts){
  if(discounts != null){
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: discounts.length,
      itemBuilder: (context, index){
        final item = discounts[index];
        return Text(
          '${item['label']}: -${currencyWithPrice(item['amount'])}',
        );
      }
    );
  }

  return Container();    
}