

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
import 'checkout/cartSummary.dart';
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
    final AccountsProvider authenticationState = Provider.of<AccountsProvider>(context);
    if (authenticationState.token != null && authenticationState.token.isNotEmpty) {
      return customerTotal(context);
    } else {
      return guestTotal(context);
    } 
  }

  Widget customerTotal(BuildContext context){
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
        if(sumCart != null){
          dynamic cartId = sumCart['id'];
          return Query(
            options: QueryOptions(document: gql('''
            {
              cart(cart_id: "${cartId}") {
                shipping_addresses{
                  selected_shipping_method {
                    amount {
                      value
                      currency
                    }
                    carrier_title
                  }
                }
                prices {
                  subtotal_excluding_tax{
                    value
                    currency
                  }
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
              List isShipping = result.data!['cart']['shipping_addresses'];

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
                      child: summaryOrder(context, prices, discounts, isShipping),
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

        return Container();
      }
    );
  }

  Widget guestTotal(BuildContext context){
    final cartProvider = context.watch<CartProvider>();
    if (cartProvider.id.isEmpty) {
      return Container();
    }

    return Query(
      options: QueryOptions(document: gql('''
      {
        cart(cart_id: "${cartProvider.id}") {
          shipping_addresses{
            selected_shipping_method {
              amount {
                value
                currency
              }
              carrier_title
            }
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
        List isShipping = result.data!['cart']['shipping_addresses'];

        // return summaryOrder(context, prices, discounts);
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
                child: summaryOrder(context, prices, discounts, isShipping)
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
      // print(destination_cart_id);
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
            ... on ConfigurableCartItem{
              id
              configurable_options{
                id
                value_id
                value_label
                option_label
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

        dynamic sumCart = result.data!['cart'];
        if(sumCart != null){
          List items = sumCart['items'];
          if (items.isEmpty) {
            return Container(
              child: Text('You have no items in your shopping cart'),
            );
          }
          return productItemCart(context, items);
        }
        return Container();
      }
    );
  }

  Widget cartCustomer(BuildContext context){
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
        if(sumCart != null){
          dynamic cartId = sumCart['id'];
          return Query(
            options: QueryOptions(document: gql('''
            {
              cart(cart_id: "${cartId}") {
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
                  ... on ConfigurableCartItem{
                    id
                    configurable_options{
                      id
                      value_id
                      value_label
                      option_label
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

              dynamic sumCart = result.data!['cart'];
              if(sumCart != null){
                List items = sumCart['items'];
                if (items.isEmpty) {
                  return Container(
                    child: Text('You have no items in your shopping cart'),
                  );
                }
                return productItemCart(context, items);
              }
              return Container();
            }
          );
        }

        return Container();
      }
    );
  }

  Widget productItemCart(BuildContext context, dynamic items){
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
                    child: Image.network(
                      item['product']['thumbnail']['url'],
                      errorBuilder:
                          (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return const Text('Image not found');
                      },
                    )
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
                          loadSpecificTypesOption(context, item),
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