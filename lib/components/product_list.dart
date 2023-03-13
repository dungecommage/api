

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../theme.dart';
import 'product_item.dart';

class ProductList extends StatelessWidget {
  int id;
  String title;

   ProductList({
    Key? key,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorTheme
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Query(
          options: QueryOptions(
            document: gql(
              '''{
                products(filter: {category_id: {eq: "$id"}}) {
                  total_count
                  items {
                    name
                    url_key
                    sku
                    image{
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
            List pritems = result.data!['products']['items'];
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: pritems.map<Widget>((option) => Container(
                  width: 200,
                  margin: EdgeInsets.only(right: 20),
                  child: productBox(
                    context,
                    option
                  ),
                )).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}