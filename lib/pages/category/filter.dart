

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../theme.dart';



class FilterProduct extends StatefulWidget {
  int id;

  FilterProduct({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<FilterProduct> createState() => _FilterProductState();
}

class _FilterProductState extends State<FilterProduct> {
  dynamic color = null;
  dynamic climate = null;
  // List<dynamic> listAtt = [$color];
  
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(
          '''{
            products(filter: { 
              category_id: { eq: "${widget.id}" },
              color: {eq: $color},
              climate: {eq: $climate}
            }) {
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
    
        List filters = result.data!['products']['aggregations'];
        return Container(
          child: SingleChildScrollView(
            child: ListView.builder(
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
                      child: Column(
                        children: [
                          Text(
                              '${attrCode}',
                            ),
                          Theme(
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
                                          setState(() {
                                              // valclimate = int.parse(option['value']);
                                              attrCode = int.parse(option['value']);
                                              print(attrCode);
                                            });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                          margin: EdgeInsets.only(right: 10, bottom: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: colorGreyBorder),
                                            borderRadius: BorderRadius.circular(4)
                                          ),
                                          child: Column(
                                            children: [
                                              Text('${option['label']}'),
                                              (attrCode == "price")? 
                                              // ListView.builder(
                                              //   shrinkWrap: true,
                                              //   physics: NeverScrollableScrollPhysics(),
                                              //   itemBuilder: (context, index){
                                              //     String textPrice = option['value'];
                                              //     List<String> listPrice = textPrice.split("_");
                                              //     print(listPrice);
                                              //     // final itemPrice = listPrice[index];
                                              //     return Column(
                                              //       children: [
                                      
                                              //       ],
                                              //     );
                                              //   },
                                              // )
                                              Text('price')
                                              : Text('${option['value']}'),
                                              Text(
                                                '(${option['count']})',
                                                style: TextStyle(
                                                  color: colorGrey1,
                                                  fontSize: 11
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
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class toInt {
  toInt(this.someProp);
  int someProp;
}