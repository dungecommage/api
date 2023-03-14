import 'package:connect_api/components/product_list.dart';
import 'package:connect_api/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../components/header_type1.dart';
import '../components/page_subtitle.dart';
import '../components/product_item.dart';
import '../product_utils.dart';
import '../providers/cart.dart';
import '../utils.dart';
import 'product/product_des.dart';
import 'product/product_info.dart';
import 'product/product_media.dart';
import 'product/product_related.dart';

class ProductPage extends StatelessWidget {
  // final _formKey = GlobalKey<FormBuilderState>();

  final String sku;
  ProductPage({
    Key? key,
    required this.sku
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Product",),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Query(
                        options: QueryOptions(
                          document: gql(
                            '''{
                              products(filter: { sku: { eq: "$sku" }}) {
                                items {
                                  review_count
                                    rating_summary
                                    reviews {
                                      items {
                                        average_rating
                                        summary
                                        text
                                        created_at
                                        nickname
                                      }
                                    }
                                  image {
                                    url
                                  }
                                  media_gallery {
                                    url
                                    label
                                  }
                                  name 
                                  sku
                                  __typename
                                  price_range {
                                    minimum_price {
                                      regular_price {
                                        value
                                        currency
                                      }
                                      final_price {
                                        value
                                        currency
                                      }
                                      discount {
                                        amount_off
                                        percent_off
                                      }
                                    }
                                  }
                                  short_description {
                                    html
                                  }
                                  description {
                                    html
                                  }
                                  ... on ConfigurableProduct {
                                    configurable_options {
                                      label
                                      values {
                                        label
                                      }
                                    }
                                    variants {
                                      product {
                                        sku
                                      }
                                      attributes {
                                        label
                                        code
                                      }
                                    }
                                  }
                                  ... on BundleProduct {
                                    items {
                                      title
                                      option_id
                                      type
                                      options {
                                        label
                                        id
                                      }
                                    }
                                  }
                                  related_products {
                                    name
                                    sku
                                    image {
                                      url
                                    }
                                    price_range {
                                      minimum_price {
                                        regular_price {
                                          value
                                          currency
                                        }
                                        final_price {
                                          value
                                          currency
                                        }
                                        discount {
                                          amount_off
                                          percent_off
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }'''
                          ),
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
                      
                          dynamic item = result.data!['products']['items'][0];
                          final price = item['price_range']['minimum_price'];
                
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProductMedia(item: item),
                                    productInfo(context, item),
                                    loadSpecificTypesOption(context, item),
                                    Container(
                                      width: context.w,
                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: colorGreyBg,
                                        borderRadius: BorderRadius.circular(11)
                                      ),
                                       child: Wrap(
                                        spacing: 7,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                           Text(
                                            currencyWithPrice(
                                              price['final_price']
                                            ),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Visibility(
                                            visible: (price['discount']['percent_off'] == 0)? false : true,
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
                                        ]
                                       ),
                                     ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 15),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 4,
                                            child: Container(
                                              margin: EdgeInsets.only(right: 15),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: colorGreyBg),
                                                borderRadius: BorderRadius.circular(11)
                                              ),
                                              child: FormActions(),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 6,
                                            fit: FlexFit.tight,
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              child: Text('Add to cart'),
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size.fromHeight(40)
                                              ),
                                            ),
                                          )
                                          
                                        ],
                                      ),
                                    ),
                                    Query(
                                      options: QueryOptions(
                                        document: gql(
                                          '''{
                                            cmsBlocks(identifiers: ["cms_block_test"]) {
                                              items {
                                                content
                                              }
                                            }
                                          }'''
                                        )
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
                
                                        List contentBlock = result.data!['cmsBlocks']['items'];
                                        return Container(
                                          padding: EdgeInsets.only(top: 10, left: 10, right: 20),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: colorTheme),
                                            borderRadius: BorderRadius.circular(11)
                                          ),
                                          child: Html(
                                            data: contentBlock[0]['content'],
                                            style: {
                                              'ul': Style(
                                                padding: EdgeInsets.zero,
                                              ),
                                              "li": Style(
                                                listStyleType: ListStyleType.none,
                                                padding: EdgeInsets.only(bottom: 7),
                                              ),
                                            },
                                          ),
                                        );
                                      }
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
                                    productRelated(context, item),
                                    
                                    ProductList(
                                      id: 21,
                                      title: 'Best Combo',
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
                                    productDescription(context, item),
                                  ],
                                ),
                              ),
                              // Container(
                              //   child: orderMutation(item, cartProvider),
                              // )
                             
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadSpecificTypesOption(BuildContext context, dynamic data) {
    final types = data['__typename'];
    if (types == 'ConfigurableProduct') {
      return getConfigurableOptions(context, data);
    } 
    // else if (types == 'BundleProduct') {
    //   return getBundleItem(context, data);
    // }
    return Container();
  }

  Widget getConfigurableOptions(BuildContext context, dynamic data) {
    var configurableOptions = data['configurable_options'];
    if (configurableOptions == null) {
      return Container();
    }

    return Column(
      children: configurableOptions.map<Widget>((configO) => 
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                '${configO['label']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Wrap(
              children: configO['values'].map<Widget>((valO){
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorGreyBorder),
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Text('${valO['label']}'),
                );
              }).toList(),
            )
          ],
        ),
      )).toList(),
    );
  }

  Widget orderMutation(dynamic item, CartProvider cartProvider) {
    var mutationString = '';
    final types = item['__typename'];
    if (types == 'SimpleProduct') {
      mutationString = Product.simple;
    } else if (types == 'VirtualProduct') {
      mutationString = Product.virtual;
    } else if (types == 'ConfigurableProduct') {
      mutationString = Product.configurable;
    }

    if (mutationString.isEmpty) {
      return ElevatedButton(
        child: Text('Add to cart'),
        onPressed: null,
      );
    }

    return Mutation(
      options: MutationOptions(
        document: gql(mutationString),
        onCompleted: (data) => print(data),
        onError: (error) => print(error),
      ),
      builder: (runMutation, result) {
        return ElevatedButton(
            child: Text('Add to cart'),
            onPressed: () {
              if (types == 'SimpleProduct') {
                runMutation({
                  'id': cartProvider.id,
                  // 'qty': _formKey.currentState.value['quantity'],
                  'sku': sku
                });
              }
      });
      },
    );
  }
}

class FormActions extends StatefulWidget {
  const FormActions({super.key});

  @override
  State<FormActions> createState() => _FormActionsState();
}

class _FormActionsState extends State<FormActions> {
  int value = 1;
  // final myController = TextEditingController();
   @override
  void initState() {
    super.initState();
    final String _value = value.toString();
  }

  void toggleIncrease() {
    setState(() {
      value++;
    });
  }
  void toggleDecrease() {
    (value == 1)? 1 : setState(() {
      value--;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: InkWell(
            onTap: () {
              toggleDecrease();
              print(value);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: colorGreyBg,
                borderRadius: BorderRadiusDirectional.circular(4)
              ),
              child: Icon(
                FontAwesomeIcons.minus,
                size: 14,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 6,
          child: Container(
            height: 30,
            child: TextFormField(
              // controller: myController,
              key: Key('${value}'),
              initialValue: '${value}',
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
              )
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: InkWell(
            onTap: () {
              toggleIncrease();
              print(value);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(4),
                color: colorGreyBg,
              ),
              child: Icon(
                FontAwesomeIcons.plus,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}