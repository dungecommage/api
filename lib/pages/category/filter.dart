

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../theme.dart';

class FilterProduct extends StatelessWidget {
  int id;

  FilterProduct({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(
          '''{
            products(filter: { category_id: { eq: "$id" } }) {
              aggregations{
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
                                  children: options.map((option) => Container(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    margin: EdgeInsets.only(right: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: colorGreyBorder),
                                      borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Text('${option['label']}'),
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
            ),
          ),
        );
      },
    );
  }
}