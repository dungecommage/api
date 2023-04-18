

import 'package:connect_api/theme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../components/footer.dart';
import '../components/header_type1.dart';
import '../graphql/query.dart';
import '../utils.dart';
import 'checkout/cartSummary.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int isSelectedPayment = 0;
  int isSelectedShipping = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Checkout",),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Query(
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
                        print(cartId);
                        return contentCheckout(context, cartId);
                      }
                      
                      return Container();
                    }
                  ),
                ),
              )
            ),
            summaryCheckout(context),
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget summaryCheckout(BuildContext){
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

  Widget contentCheckout(BuildContext context, dynamic cartId){
    return Query(
      options: QueryOptions(
        document: gql('''
          {
            cart(cart_id: "${cartId}") {
              email
              billing_address {
                city
                country {
                  code
                  label
                }
                firstname
                lastname
                postcode
                region {
                  code
                  label
                }
                street
                telephone
              }
              shipping_addresses {
                firstname
                lastname
                street
                city
                region {
                  code
                  label
                }
                country {
                  code
                  label
                }
                telephone
                available_shipping_methods {
                  amount {
                    currency
                    value
                  }
                  available
                  carrier_code
                  carrier_title
                  error_message
                  method_code
                  method_title
                  price_excl_tax {
                    value
                    currency
                  }
                  price_incl_tax {
                    value
                    currency
                  }
                }
                selected_shipping_method {
                  amount {
                    value
                    currency
                  }
                  carrier_code
                  carrier_title
                  method_code
                  method_title
                }
              }
              items {
                id
                product {
                  name
                  sku
                }
                quantity
                errors {
                  code
                  message
                }
              }
              available_payment_methods {
                code
                title
              }
              selected_payment_method {
                code
                title
              }
              applied_coupons {
                code
              }
              prices {
                grand_total {
                  value
                  currency
                }
              }
            }
          }
        ''')
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

        dynamic cart = result.data!['cart'];
        List avShipping = cart['shipping_addresses'][0]['available_shipping_methods'];
        List avPayment = cart['available_payment_methods'];

        return Container(
          child: Column(
            children: [
              Text(
                'Email: ${cart['email']}',
              ),
              shippingMethod(context, avShipping),
              paymentMethod(context, avPayment)
            ],
          ),
        );
      }
    );
  }

  Widget shippingMethod(BuildContext context, dynamic avShipping){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping  Method',
            style: PrimaryFont.bold(16),
          ),
          SizedBox(height: 10,),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: avShipping.length,
            itemBuilder: (context, index){
              final item = avShipping[index];
              return Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: colorWhite,
                  boxShadow: [
                    BoxShadow(
                      color: colorBlack.withOpacity(0.1),
                      blurRadius: 10,
                        offset: Offset(0,0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(6)
                ),
                // child: Text('${item['carrier_title']}'),
                child: RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity
                  ),
                  value: index,
                  groupValue: isSelectedShipping,
                  onChanged: (val) {
                    setState(() {
                      isSelectedShipping = val!;
                    });
                  },
                  selected: isSelectedShipping == index,
                  title: Text("${item['carrier_title']} |  ${currencyWithPrice(item['amount'])}"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget paymentMethod(BuildContext context, dynamic avPayment){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: PrimaryFont.bold(16),
          ),
          SizedBox(height: 10,),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: avPayment.length,
            itemBuilder: (context, index){
              final item = avPayment[index];
              return Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: colorWhite,
                  boxShadow: [
                    BoxShadow(
                      color: colorBlack.withOpacity(0.1),
                      blurRadius: 10,
                        offset: Offset(0,0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(6)
                ),
                child: RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity
                  ),
                  value: index,
                  groupValue: isSelectedPayment,
                  onChanged: (val) {
                    setState(() {
                      isSelectedPayment = val!;
                    });
                  },
                  selected: isSelectedPayment == index,
                  title: Text("${item['title']}"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}