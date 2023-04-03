

import 'package:connect_api/theme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../components/header_type1.dart';
import '../../grapql/query.dart';
import 'sidebar.dart';

class AccDashBoard extends StatefulWidget {
  const AccDashBoard({super.key});

  @override
  State<AccDashBoard> createState() => _AccDashBoardState();
}

class _AccDashBoardState extends State<AccDashBoard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "My Account"),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: context.w,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SidebarAccount(),
                        SizedBox(height: 10,),
                        Query(
                          options: QueryOptions(
                            document: gql(customerInfo)
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

                            final cus = result.data!['customer'];
                            List cusAddress = result.data!['customer']['addresses'];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'Contact Information',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                    ),
                                  )
                                ),
                                Container(
                                  width: context.w,
                                  padding: EdgeInsets.all(10),
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
                                      Text("${cus['firstname']} ${cus['lastname']}"),
                                      SizedBox(height: 5),
                                      Text("${cus['email']}"),
                                      SizedBox(height: 10),
                                      Wrap(
                                        spacing: 10,
                                        children: [
                                          TextButton(
                                            onPressed: () {}, 
                                            child: Text(
                                              'Edit',
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {}, 
                                            child: Text('Change Password')
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ),
                                
                                SizedBox(height: 20,),
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
                                      TextButton(
                                        onPressed: () {}, 
                                        child: Text('Manage')
                                      ),
                                    ],
                                  )
                                ),
                                ListView.builder(
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
                                      child: Text(
                                        "${item['firstname']} ${item['lastname']}, ${item['street']}, ${item['city']}, ${item['telephone']}"
                                      ),
                                    );
                                  }
                                )
                              ],
                            );
                          }
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Orders',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                                ),
                              ),
                              TextButton(
                                onPressed: () {}, 
                                child: Text('View all')
                              ),
                            ],
                          )
                        ),
                        Query(
                          options: QueryOptions(document: gql(customerOrders)), 
                          builder: (result, {fetchMore, refetch}) {
                            if (result.hasException) {
                              return Text(result.exception.toString());
                            }
                        
                            if (result.isLoading) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            List cusOrder = result.data!['customerOrders']['items'];
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cusOrder.length < 5 ? cusOrder.length : 5,
                              itemBuilder: (context, index){
                                final item = cusOrder[index];
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
                                      Text("Order number: ${item['order_number']}"),
                                      SizedBox(height: 5,),
                                      Text("Order date: ${item['created_at']}"),
                                      SizedBox(height: 5,),
                                      Text("Price: ${item['grand_total']}"),
                                      SizedBox(height: 5,),
                                      Text("Status: ${item['status']}"),
                                    ],
                                  ),
                                );
                              }
                            );
                          }
                        )
                        
                      ],
                    ),
                  ),
                )
              )
            )
          ]
        )
      )
    );
  }
}