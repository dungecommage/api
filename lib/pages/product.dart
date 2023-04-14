import 'package:connect_api/components/product_list.dart';
import 'package:connect_api/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../components/footer.dart';
import '../components/header_type1.dart';
import '../components/modal_title.dart';
import '../components/page_subtitle.dart';
import '../components/product_item.dart';
import '../components/validate.dart';
import '../graphql/mutation.dart';
import '../product_utils.dart';
import '../providers/cart.dart';
import '../utils.dart';
import 'product/product_des.dart';
import 'product/product_media.dart';
import 'product/product_related.dart';

class ProductPage extends StatefulWidget {
  final String sku;
  ProductPage({
    Key? key,
    required this.sku
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final Map<String, String> _formValues = {};
  List<int> listRating_selected = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool hasRating = false;
  int initVal = 1;  

  bool validateAndSave(){
    final form = _formKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    return false;
  }

//  @override
//   void initState() {
//     super.initState();
//     final String _initVal = initVal.toString();
//   }

  void toggleIncrease() {
    setState(() {
      initVal++;
    });
  }
  void toggleDecrease() {
    (initVal == 1)? 1 : setState(() {
      initVal--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = context.watch<CartProvider>();
    if (cartProvider.id.isEmpty) {
      getCart(context);
    }

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
                              products(filter: { sku: { eq: "${widget.sku}" }}) {
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
                                        value_index
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
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // ProductMedia(item: item),
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
                                                // decoration: BoxDecoration(
                                                //   border: Border.all(color: colorGreyBg),
                                                //   borderRadius: BorderRadius.circular(11)
                                                // ),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      flex: 2,
                                                      child: InkWell(
                                                        onTap: () {
                                                          toggleDecrease();
                                                        },
                                                        child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadiusDirectional.circular(4),
                                                            color: colorGreyBg,
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
                                                      child: TextFormField(
                                                        key: Key('${initVal}'),
                                                        initialValue: '${initVal}',
                                                        keyboardType: TextInputType.number,
                                                        textAlign: TextAlign.center,
                                                        onChanged: (String? val) {
                                                          if(val != ""){
                                                            initVal = int.parse(val!);
                                                          }                                                   
                                                        },
                                                        onSaved: (String? val) {
                                                          if(val != ""){
                                                            initVal = int.parse(val!);
                                                          }  
                                                        },
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 2,
                                                      child: InkWell(
                                                        onTap: () {
                                                          toggleIncrease();
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
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 6,
                                              fit: FlexFit.tight,
                                              child: orderMutation(item, cartProvider),
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
                              ),                             
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Footer(),
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

    // return Column(
    //   children: configurableOptions.map<Widget>((configO) => 
    //   Container(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.only(bottom: 5),
    //           child: Text(
    //             '${configO['label']}',
    //             style: TextStyle(
    //               fontWeight: FontWeight.bold
    //             ),
    //           ),
    //         ),
    //         Wrap(
    //           children: configO['values'].map<Widget>((valO){
    //             return Container(
    //               padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    //               margin: EdgeInsets.only(right: 10, bottom: 10),
    //               decoration: BoxDecoration(
    //                 border: Border.all(color: colorGreyBorder),
    //                 borderRadius: BorderRadius.circular(4)
    //               ),
    //               child: Text('${valO['label']}'),
    //             );
    //           }).toList(),
    //         )
    //       ],
    //     ),
    //   )).toList(),
    // );

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: configurableOptions.length,
      itemBuilder: (context, index){
        final item = configurableOptions[index];
        List option = item['values'];
        return Column(
          children: [
            Text(
              "${item['label']}",
              style: PrimaryFont.bold(14),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: option.length,
              itemBuilder: (context, i){
                final valOption = option[i];
                return InkWell(
                  onTap: () {
                    print(valOption['value_index']);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                    color: colorWhite,
                      boxShadow: [
                        BoxShadow(
                          color: colorBlack.withOpacity(0.1),
                          blurRadius: 10,
                            offset: Offset(0,0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text('${valOption['value_index']}'),
                        Text('${valOption['label']}'),
                      ],
                    ),
                  ),
                );
              }
            )
          ],
        );
      }
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
        onCompleted: (data) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("You added product to your shopping cart."),
            ),
          );
        },
        onError: (error) => print(error),
      ),
      builder: (runMutation, result) {
        return ElevatedButton(
          child: Text('Add to cart'),
          onPressed: () {
            var qty = initVal;
            if (types == 'SimpleProduct') {
              runMutation({
                'id': cartProvider.id,
                'qty': qty,
                'sku': widget.sku
              });
            }
          }
        );
      },
    );
  }

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
            runSpacing: 7,
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
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: context.w,
                          color: colorWhite,
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Column(
                            children: [
                              AlertDialogTitle(data: 'Your Review'),
                              Container(
                                height: context.h * 0.8 - MediaQuery.of(context).viewInsets.bottom,
                                child: SingleChildScrollView(
                                  child: formReview(context),
                                )
                              )
                            ],
                          )
                        ), 
                      ],
                    ),
                  ),
                ),
                child: Text("Add Your Review"),
              ),
              
            ],
          ),
        ),
      ],
    );
  }

  Widget formReview(BuildContext context){
    double valRating = 0;
    bool showForm = false;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Rating'),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 20),
            child: RatingBar(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemSize: 26,
              ratingWidget: RatingWidget(
                full: Icon(FontAwesomeIcons.solidStar, color: Colors.amber,),
                half: Icon(FontAwesomeIcons.star, color: colorGrey1,),
                empty: Icon(FontAwesomeIcons.star, color: colorGrey1),
              ),
              
              onRatingUpdate: (rating) {
                setState(() {
                  valRating = rating;
                  showForm = true;
                  print(showForm);
                });
              },
            ),
          ),
          Text('Nickname'),
          Container(
            height: 42,
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: TextFormField(
              validator: validateEmpty,
              onChanged: (String? val) {
                _formValues['nickname'] = val!;
              },
              onSaved: (String? val) {
                _formValues['nickname'] = val!;
              },
            ),
          ),
          Text('Summary'),
          Container(
            height: 42,
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: TextFormField(
              validator: validateEmpty,
              onChanged: (String? val) {
                _formValues['summary'] = val!;
              },
              onSaved: (String? val) {
                _formValues['summary'] = val!;
              },
            ),
          ),
          Text('Review'),
          Container(
            height: 42,
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: TextFormField(
              validator: validateEmpty,
              onChanged: (String? val) {
                _formValues['text'] = val!;
              },
              onSaved: (String? val) {
                _formValues['text'] = val!;
              },
            ),
          ),
          Mutation(
            options: MutationOptions(
              document: gql(createProductReview),
              onCompleted: (data) async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductPage(sku: widget.sku,)),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Thank for your review"),
                  ),
                );
              },
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                  ),
                );
                // print(error.toString());
              },
            ),
            builder: (runMutation, result) {
              return ElevatedButton(
                onPressed: () {
                  if(validateAndSave()){
                    runMutation({
                      'sku': widget.sku,
                      'nickname': _formValues['nickname'],
                      'summary': _formValues['summary'],
                      'text': _formValues['text'],
                      'id': "NA==",
                      'value_id': valRating,
                    });
                    
                  }
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(40),
                ),
              );
            },
          ),
          
        ],
      ),
    );
  }
}