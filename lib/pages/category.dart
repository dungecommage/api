import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../components/header_type1.dart';
import '../components/modal_title.dart';
import '../components/product_item.dart';
import '../grapql/query.dart';
import '../theme.dart';
import '../utils.dart';
import 'product.dart';

class CategoryPage extends StatefulWidget {
  int categoryId;
  CategoryPage({
    Key? key,
    // required this.title,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Category",),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Query(
                        options: QueryOptions(
                          document: gql(
                            '''
                              {
                                categoryList(filters: {ids: {in: "${widget.categoryId}"}}) {
                                  name
                                  children {
                                    id
                                    name
                                  }
                                }
                              }
                            '''
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
                          
                          List cate = result.data!['categoryList'];
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  '${cate[0]['name']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                      Query(
                        options: QueryOptions(
                          document: gql(
                            '''{
                              products (filter: {
                                category_id: {eq: "${widget.categoryId}"}
                              }){
                                total_count
                                aggregations{
                                  attribute_code
                                  label
                                  options{
                                    count
                                    label
                                    value
                                  }
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

                          dynamic parent = result.data!['products'];
                          List aggList = parent['aggregations'];
                          List listAtrr = aggList.map((list) => list['attribute_code']).toList();
                          print(listAtrr);

                          return Container(
                            child: Text('123'),
                          );
                        }
                      )
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
}