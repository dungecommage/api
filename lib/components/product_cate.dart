

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'product_item.dart';

class ProductCategory extends StatelessWidget {
  int idCate;
  ProductCategory({
    Key? key,
    required this.idCate
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(
          '''
            {
              products (filter: {category_id: {eq: "$idCate"}}){
                total_count
                items{
                  id
                  sku
                  name
                  url_key
                  stock_status
                  thumbnail{
                    url
                    label
                    position
                  }
                  image{
                    url
                    label
                    position
                  }
                  price_range{
                    minimum_price{
                      regular_price{
                        value
                        currency
                      }
                      final_price{
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
          '''
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

        List pritems = result.data!['products']['items'];

        return AlignedGridView.count(
          physics: NeverScrollableScrollPhysics(),
          itemCount: pritems.length,
          shrinkWrap: true,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          crossAxisCount: 2,
            itemBuilder: (context, index) {
              final pritem = pritems[index];
              return productBox(
                context,
                pritem,
              );
            },
          );
      }
    );
  }
}