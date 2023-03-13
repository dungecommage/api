

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SortBy extends StatelessWidget {
  int id;

  SortBy({
    Key? key,
    required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(
          '''{
              products(filter: {category_id: {eq: "$id"}}) {
                sort_fields {
                  default
                  options {
                    label
                    value
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
        List options = result.data!['products']['sort_fields']['options'];
        return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: options.length,
        shrinkWrap: true,
          itemBuilder: (context, index) {
            final option = options[index];
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text('${option['label']}'),
            );
          },
        );
      },
    );
  }
}