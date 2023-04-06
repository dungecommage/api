

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../components/header_type1.dart';
import '../graphql/query.dart';
import '../theme.dart';
import '../utils.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Query(
                options: QueryOptions(
                  document: gql(customerCart)
                ), 
                builder: (result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
              
                  if (result.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
        
                  dynamic sumCart = result.data!['customerCart'];
                  dynamic sumPrice = sumCart['prices'];
                  List cusCart = sumCart['items'];
                  return  Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Subtotal"),
                                Text(
                                  currencyWithPrice(
                                    sumPrice['subtotal_excluding_tax']
                                  )
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Order Total"),
                                Text(
                                  currencyWithPrice(
                                    sumPrice['grand_total']
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cusCart.length,
                        itemBuilder: (context, index){
                          final item = cusCart[index];
                          final product = item['product'];
                          final url = product['thumbnail']['url'];
                          final price = product['price_range']['minimum_price'];
                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 10),
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
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Image.network(url)
                                ),
                                Flexible(
                                  flex: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${product['name']}"),
                                        SizedBox(height: 5,),
                                        loadSpecificTypesOption(context, item),
                                        SizedBox(height: 5,),
                                        Wrap(
                                          spacing: 10,
                                          children: [
                                            Text(
                                              currencyWithPrice(
                                                price['final_price']
                                              )
                                            ),
                                            Visibility(
                                              visible: (price['regular_price']['value'] == price['final_price']['value'])? false : true,
                                              child: Text(
                                                currencyWithPrice(
                                                  price['regular_price']
                                                ),
                                                style: TextStyle(
                                                  decoration: TextDecoration.lineThrough,
                                                  color: colorGrey1
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Qty: ${item['quantity']}"),
                                            OutlinedButton.icon(
                                              onPressed: () {},
                                              icon: Icon(
                                                FontAwesomeIcons.trash,
                                                size: 14,
                                              ), 
                                              label: Text('Delete'),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: colorGrey1,
                                                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                                                minimumSize: Size.zero
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                )
                              ],
                            ),
                          );
                        }
                      ),
                    ],
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget loadSpecificTypesOption(BuildContext context, dynamic item) {
    final types = item['__typename'];
    if (types == 'ConfigurableCartItem') {
      return getConfigurableOptions(context, item);
    } 

    return Container();
  }

  Widget getConfigurableOptions(BuildContext context, dynamic data) {
    var configurableOptions = data['configurable_options'];
    if (configurableOptions == null) {
      return Container();
    }

    return Container(
      child: Wrap(
        children: configurableOptions.map<Widget>((cf) {
          return Container(
            margin: EdgeInsets.only(right: 5),
            child: Text('${cf['value_label']}'),
          );
        }).toList(),
      )
    );
  }
}