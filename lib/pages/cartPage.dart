

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../components/footer.dart';
import '../components/header_type1.dart';
import '../graphql/query.dart';
import '../providers/accounts.dart';
import '../providers/cart.dart';
import '../theme.dart';
import '../utils.dart';
import 'checkout.dart';
import 'product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Shopping Cart",),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: accountsCart(context),
                ),
              )
            ),
            rowTotal(context),
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget rowTotal(BuildContext context){
    final cartProvider = context.watch<CartProvider>();
    if (cartProvider.id.isEmpty) {
      return Container();
    }
    return Query(
      options: QueryOptions(document: gql('''
      {
        cart(cart_id: "${cartProvider.id}") {
          items {
            id
          }
          prices {
            grand_total {
              value
              currency
            }
            discounts{
              amount{
                value
                currency
              }
              label
            }
          }
        }
      }
      ''')),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        dynamic prices = result.data!['cart']['prices'];
        List discounts = prices['discounts'];
        List items = result.data!['cart']['items'];

        if (items.isEmpty) {
          return Container();
        }
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                flex: 6,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("Order Total"),
                    // SizedBox(height: 3,),
                    Text(
                      'Order Total: ${currencyWithPrice(prices['grand_total'])}',
                      style: PrimaryFont.bold(16),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: discounts.length,
                      itemBuilder: (context, index){
                        final item = discounts[index];
                        return Text(
                          '${item['label']}: ${currencyWithPrice(item['amount'])}',
                          style: TextStyle(
                            // color: colorGrey1,
                            fontSize: 12
                          ),
                        );
                      }
                    )
                  ],
                )
              ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                        MaterialPageRoute(builder: (context) => Checkout()
                      ),
                    );
                  },
                  child: Text("Checkout"),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget accountsCart(BuildContext context) {  
    final AccountsProvider authenticationState = Provider.of<AccountsProvider>(context);
    if (authenticationState.token != null && authenticationState.token.isNotEmpty) {
      print(authenticationState.token);
      return cartCustomer(context);
    } else {
      return guestCart(context);
    }   
  }

  Widget guestCart(BuildContext context){
    final cartProvider = context.watch<CartProvider>();
    if (cartProvider.id.isEmpty) {
      return Container(
        child: Text('You have no items in your shopping cart'),
      );
    }

    return Query(
      options: QueryOptions(document: gql('''
      {
        cart(cart_id: "${cartProvider.id}") {
          items {
            id
            product {
              name
              sku
              thumbnail {
                url
              }
              price_tiers {
                final_price {
                  value
                  currency
                }
              }
            }
            prices {
              row_total {
                value
                currency
              }
            }
            quantity
          }
          prices {
            grand_total {
              value
              currency
            }
          }
        }
      }
      ''')),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List items = result.data!['cart']['items'];

        if (items.isEmpty) {
          return Container(
            child: Text('You have no items in your shopping cart'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Image.network(item['product']['thumbnail']['url'])
                      ),
                      Flexible(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['product']['name']),
                              SizedBox(height: 5,),
                              Text(
                                'Price: ${currencyWithPrice(item['prices']['row_total'])}',
                              ),
                              SizedBox(height: 5,),
                              Text('Qty: ${item['quantity']}'),
                              SizedBox(height: 7,),
                              Container(
                                width: double.infinity,
                                child: Wrap(
                                  spacing: 10,
                                  alignment: WrapAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //     MaterialPageRoute(builder: (context) => ProductPage(sku: item['product']['sku'],)
                                        //   ),
                                        // );
                                      }, 
                                      icon: Icon(
                                        FontAwesomeIcons.pencil,
                                        size: 14,
                                      ), 
                                      label: Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: 12
                                        ),
                                      )
                                    ),
                                    deleteItems(context, item['id'], items, index),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),                      
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }

  Widget cartCustomer(BuildContext){
    return Query(
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

  Widget deleteItems(BuildContext context, String id, dynamic items, int index) {
    return Mutation(
      options: MutationOptions(
        document: gql('''
          mutation RemoveItem(\$cartId: String!, \$itemId: Int!) {
            removeItemFromCart(
              input: {
                cart_id: \$cartId,
                cart_item_id: \$itemId
              }
            ) {
              cart {
                items {
                  product {
                    name
                  }
                }
              }
            }
          }
        ''')
        ),
      builder: (runMutation, result) {
        final cartProvider = context.watch<CartProvider>();
        return OutlinedButton.icon(
          onPressed: () {
            runMutation({
              'cartId': cartProvider.id,
              'itemId': id,
            });
            setState(() {
              items.removeAt(index);
            });
          }, 
          icon: Icon(
            FontAwesomeIcons.pencil,
            size: 14,
          ), 
          label: Text(
            'Delete',
            style: TextStyle(
              fontSize: 12
            ),
          )
        );
      },
    );
  }
}