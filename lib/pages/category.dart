import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../components/footer.dart';
import '../components/header_type1.dart';
import '../components/modal_title.dart';
import '../components/product_item.dart';
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
  bool isGrid = true;
  int currentP = 1;
  bool _removeFilter = true;
  bool _activeBox = false;
  int? color = null;
  int? size = null;
  int? fromPrice = null;
  int? toPrice = null;
  String sortName = "position";
  String sortField = "ASC";

  List currentAttr = [];
  List currentLabel = [];

  Set<String> listSort_selected = Set();

  void changeSort(){
    if(sortField == "ASC"){
      setState(() {
        sortField = "DESC";
      });
    } else{
      setState(() {
        sortField = "ASC";
      });
    }
}

  void removeFilter(){
    setState(() {
      color = null;
      size = null;
      fromPrice = null;
      toPrice = null;
      currentAttr = [];
      currentLabel = [];
    });
  }

  @override
  initState() {
    super.initState();
    setState(() {
      listSort_selected.add("position");
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: 'Catgegory'),
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
                              categoryList(filters: {ids: {in: "${widget.categoryId}"}}) {
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
                        child: Query(
                          options: QueryOptions(
                            document: gql(
                              '''{
                                products(
                                  pageSize: 12,
                                  currentPage: $currentP
                                  filter: {
                                    category_id: {eq: "${widget.categoryId}"},
                                    color: {eq: $color},
                                    size: {eq: $size},
                                    price: {from: $fromPrice, to: $toPrice}
                                  },
                                  sort: {
                                    $sortName: $sortField
                                  }
                                ) {
                                  total_count
                                  sort_fields {
                                    default
                                    options {
                                      label
                                      value
                                    }
                                  }
                                  aggregations{
                                    attribute_code
                                    label
                                    options{
                                      count
                                      label
                                      value
                                    }
                                  }
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
                                    short_description{
                                      html
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
                  
                            dynamic parent = result.data!['products'];
                            List pritems = result.data!['products']['items'];
                            int count = parent['total_count'];
                            int pageSize = parent['page_info']['page_size'];
                            int currentPage = parent['page_info']['current_page'];
                            int countpage = (count / pageSize).ceil();
                            List filters = parent['aggregations'];
                            List listSort = result.data!['products']['sort_fields']['options'];
                  
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
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
                                                    child: AlertDialogTitle(data: 'Filter')
                                                  ),
                                                  Container(
                                                    height: context.h * 0.8,
                                                    width: context.w,
                                                    padding: EdgeInsets.only(top: 20),
                                                    child: SingleChildScrollView(
                                                      child: popupFilter(context, filters)
                                                    ),
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
                                          Text('Filter')
                                        ]
                                      ),
                                    ),
                              
                                    Row(
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
                                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(bottom: 20),
                                                        child: AlertDialogTitle(data: 'Sort by')
                                                      ),
                                                      Container(
                                                        height: context.h * 0.8,
                                                        width: context.w,
                                                        child: popupSort(context, listSort),
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
                                              Text('Sort by')
                                            ]
                                          ),
                                        ),
                                        InkWell(
                                          child: SvgPicture.asset('assets/images/icons/sort.svg'),
                                          onTap: () {
                                            changeSort();
                                          },
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          isGrid = !isGrid;
                                        });
                                      },
                                      child: Icon(
                                        (isGrid == true)?
                                        FontAwesomeIcons.list : FontAwesomeIcons.th,
                                        size: 18,
                                      ),
                                    )
                                  ],
                                ),
                                
                                
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    (count == 0)? "Can't find product" : "${count.toString()} items"
                                  ),
                                ),
                                
                                AlignedGridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: pritems.length,
                                shrinkWrap: true,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                crossAxisCount: (isGrid == true)? 2 : 1,
                                  itemBuilder: (context, index) {
                                    final pritem = pritems[index];
                                    return (isGrid == true)?
                                      productBox(
                                      context,
                                      pritem,
                                    ) :
                                    productTypeList(
                                      context,
                                      pritem,
                                    );
                                  },
                                ),
                  
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List<Widget>.generate(countpage!, (int i){
                                        var pager = i+1;
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              currentP = pager;
                                            });
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
                                                color: (currentP == pager)? colorWhite : colorBlack
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
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
            Footer(),
          ],
        ),
      ),
    );
  }
  
  Widget popupSort(BuildContext context, dynamic sort){
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: sort.length,
      itemBuilder: (context, i){
        final item = sort[i];
        final val = sort[i]['value'];
        return InkWell(
          onTap: () {
            setState(() {
              listSort_selected = Set();
              listSort_selected.add(val);
              sortName = val;
              // Navigator.pop(context, 'Cancel');
              Navigator.of(context).pop();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: listSort_selected.contains(val) ? colorTheme : colorWhite,
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child:  Text('${item['label']}'),
          ),
        );
      }
    );
  }

  Widget popupFilter(BuildContext context, dynamic filters){
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorGreyBorder)
            ),
          ),
          child: Visibility(
            visible: (currentAttr.isEmpty)? false : true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Filter Current',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  )
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: currentAttr.length,
                  itemBuilder: (context, index){
                    var name = currentAttr[index];
                    var label = currentLabel[index];
                    return Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 0, bottom: 10, left: 25),
                          child: Text("$name: $label")
                        ),
                        Positioned(
                          top: -1,
                          left: 0,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currentAttr.removeAt(index);
                                currentLabel.removeAt(index);
                                Navigator.of(context).pop();
                              });
                              if("$name" == "Color"){
                                setState(() {
                                  color = null;
                                });
                              } 
                              else if("$name" == "Size"){
                                setState(() {
                                  size = null;
                                });
                              } 
                              else if("$name" == "Price"){
                                setState(() {
                                  fromPrice = null;
                                  toPrice = null;
                                });
                              } 
                            },                                             
                            child: Icon(
                              FontAwesomeIcons.times,
                              size: 18,
                            ),
                          )
                        )
                      ],
                    );
                  }
                ),
                ElevatedButton(
                  onPressed: (){
                    removeFilter();
                    Navigator.of(context).pop();
                  }, 
                  child: Text('Clear all Filter')
                ),
              ],
            ),
          ),
        ),
        
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filters.length,
          itemBuilder: (context, index){
            final item = filters[index];
            List options = item['options'];
            dynamic attrCode = item['attribute_code'];
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: colorGreyBorder)
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTileTheme(
                      data: ExpansionTileThemeData(
                        iconColor: colorBlack,
                        collapsedIconColor: colorGrey1,
                        collapsedTextColor: colorGrey1,
                        textColor: colorBlack,
                      ),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        initiallyExpanded : true,
                        title: Text(
                          '${item['label']}',
                        ),
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft, 
                            child: Wrap(
                              children: options.map((option) => InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  currentAttr.add(
                                    item['label']
                                  );
                                  currentLabel.add(
                                    option['label']
                                  );
                                  setState(() {
                                    currentP = 1;
                                  });
                                  if(attrCode == 'color'){
                                    setState(() {
                                      color = int.parse(option['value']);
                                    });
                                  }        
                                  else if(attrCode == 'size'){
                                    setState(() {
                                      size = int.parse(option['value']);
                                    });
                                  }        
                                  else if(attrCode == 'category_uid'){
                                    setState(() {
                                      widget.categoryId = int.parse(option['value']);
                                    });
                                  }        
                                  else if(attrCode == 'price'){
                                    String textPrice = option['value'];
                                    List<String> listPrice = textPrice.split("_");
                                      
                                    setState(() {
                                      fromPrice = int.parse(listPrice[0]);
                                      toPrice = int.parse(listPrice[1]);
                                    });
                                  }        
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  margin: EdgeInsets.only(right: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: colorGreyBorder),
                                    borderRadius: BorderRadius.circular(4),
                                    color: (_activeBox == true)? colorTheme : colorWhite
                                  ),
                                  child: Wrap(
                                    runAlignment: WrapAlignment.center,
                                    spacing: 5,
                                    children: [
                                      Text(
                                        '${option['label']}',
                                        style: TextStyle(
                                          color: (_activeBox == true)? colorWhite : colorBlack
                                        ),
                                      ),
                                      Text(
                                        '(${option['count']})',
                                        style: TextStyle(
                                          color: (_activeBox == true)? colorWhite : colorGrey1,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )).toList()
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        )
      ],
    );    
  }
}