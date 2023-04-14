import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../components/header_type1.dart';
import '../../graphql/mutation.dart';
import '../../graphql/query.dart';
import '../../theme.dart';
import 'addnew_address.dart';
import 'edit_address.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({super.key});

  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Address Book"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Address Book',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                    MaterialPageRoute(builder: (context) => NewAddress()
                                  ),
                                );
                              }, 
                              child: Text('+ Add new')
                            ),
                          ],
                        )
                      ),
                      Query(
                        options: QueryOptions(
                          document: gql(customerInfo),
                          fetchPolicy: FetchPolicy.noCache,
                          cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
                        ), 
                        builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }) {
                          if (result.hasException) {
                            return Text(result.exception.toString());
                          }
                      
                          if (result.isLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final cus = result.data!['customer'];
                          List cusAddress = result.data!['customer']['addresses'];
                          return showAddress(context, cusAddress);
                        }
                      )
                    ],
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget showAddress(BuildContext context, dynamic cusAddress){
    if (cusAddress.isEmpty) {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Text("No items")
      );
    } 

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cusAddress.length,
      itemBuilder: (context, index){
        final item = cusAddress[index];
        return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: colorWhite,
            boxShadow: [
              BoxShadow(
                color: colorBlack.withOpacity(0.1),
                blurRadius: 10,
                  offset: Offset(0,0),
              ),
            ],
            borderRadius: BorderRadius.circular(11)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${item['firstname']} ${item['lastname']}, ${item['street']}, ${item['city']}, ${item['telephone']}"
              ),
              SizedBox(height: 7,),
              Wrap(
                spacing: 10,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(builder: (context) => EditAddress(idAddress: item['id'])
                        ),
                      );
                    }, 
                    child: Text('Edit')
                  ),
                  Visibility(
                    visible: (item['default_billing'] == true || item['default_shipping'] == true)? false : true,
                    child: Mutation(
                      options: MutationOptions(
                        document: gql(deleteCustomerAddress),
                        onCompleted: (data) async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: 
                              Text('Remove address Successfully!')
                            ),
                          );
                        },
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                            ),
                          );
                        },
                        // update: (cache, result) {
                        //   cache.writeQuery(request, data: data)
                        // },
                      ),
                      builder: (runMutation, result) {
                        return TextButton(
                          onPressed: () {
                            setState(() {
                              cusAddress.removeAt(index);
                            });
                            
                            runMutation({
                              'id': item['id'],
                            });
                            
                          }, 
                          child: Text('Delete')
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }
}