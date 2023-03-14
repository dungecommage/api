import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../components/header_type1.dart';
import '../components/modal_title.dart';
import '../components/product_item.dart';
import '../theme.dart';
import '../utils.dart';
import 'category/filter.dart';
import 'category/sort.dart';
import 'product.dart';

class CategoryPage extends StatelessWidget {
  // final String title;
  int categoryId;
  int currentP = 1;

  CategoryPage({
    Key? key,
    // required this.title,
    required this.categoryId,
  }) : super(key: key);

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
                            '''{
                              categoryList(filters: {ids: {in: "$categoryId"}}) {
                                name
                                children {
                                  id
                                  name
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
                          List cate = result.data!['categoryList'];
                          List subitems = cate[0]['children'];
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
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: subitems.map((sub) => 
                                    InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CategoryPage(
                                            categoryId: sub['id'],
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: colorBlack.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Text(
                                          sub['name'],
                                          style: TextStyle(
                                            color: colorWhite
                                          ),
                                        ),
                                      ),
                                    )).toList(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
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
                                      color: colorWhite,
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: AlertDialogTitle(data: 'Bộ lọc')
                                          ),
                                          Container(
                                            height: context.h * 0.8,
                                            width: context.w,
                                            padding: EdgeInsets.only(top: 20),
                                            child: FilterProduct(id: categoryId),
                                          ),
                                        ],
                                      )
                                    ), 
                                  ],
                                ),
                              ),
                            ),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/images/icons/filter.svg'),
                                  Text('Lọc')
                                ]
                              ),
                            ),
                      
                            TextButton(
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
                                      color: colorWhite,
                                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(bottom: 20),
                                            child: AlertDialogTitle(data: 'Sắp xếp theo')
                                          ),
                                          Container(
                                            height: context.h * 0.8,
                                            width: context.w,
                                            child: SortBy(id: categoryId),
                                          ),
                                        ],
                                      )
                                    ), 
                                  ],
                                ),
                              ),
                            ),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/images/icons/sort.svg'),
                                  Text('Sắp xếp')
                                ]
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Query(
                          options: QueryOptions(
                            document: gql(
                              '''{
                                products(
                                  pageSize: 12,
                                  currentPage: "$currentP"
                                  filter: {
                                    category_id: {eq: "$categoryId"}
                                  }
                                ) {
                                  total_count
                                  page_info {
                                    current_page
                                    page_size
                                  }
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
                            int count = result.data!['products']['total_count'];
                            int pageSize = result.data!['products']['page_info']['page_size'];
                            int currentPage = result.data!['products']['page_info']['current_page'];
                            int countpage = (count/pageSize).ceil();
                            print(countpage);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    (count == 0)? "Can't find product" : "${count.toString()} items"
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List<Widget>.generate(countpage, (int i){
                                    var pager = i+1;
                                    return InkWell(
                                      onTap: () {
                                        currentP = pager;
                                        // print(pager);
                                        print(currentP);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: (currentP == pager)? colorTheme : colorGreyBg,
                                          borderRadius: BorderRadius.circular(4)
                                        ),
                                        margin: EdgeInsets.symmetric(horizontal: 3),
                                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        child: Text(
                                          '${pager}',
                                          style: TextStyle(
                                            color: (currentPage == pager)? colorWhite : colorBlack
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                // Text('${pageSize.toString()}'),
                                AlignedGridView.count(
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
                                      pritem
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
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
}