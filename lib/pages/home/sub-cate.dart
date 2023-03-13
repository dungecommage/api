
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../category.dart';

class SubCateHome extends StatelessWidget {
  final query = """query{
    categoryList(filters: {ids: {in: "2"}}) {
      children_count
      children {
        id
        name
        url_key
        image
      }
    }
  }""";

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(query)),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }
    
        if (result.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    
        List items = result.data!['categoryList'][0]['children'];
        return Container(
          
          child: MasonryGridView.count(
          shrinkWrap: true,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          crossAxisCount: 4,
          itemCount: items.length,
          itemBuilder: (context, index){
            final item = items[index];
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPage(
                    categoryId: item['id'],
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Image.network(item['image'])
                  ),
                  Text(
                    "${item['name']}",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${item['id']}",
                  ),
                ],
              ),
            );
          },
          ),
        ); 
      }
    );
  }
}