import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/header_type1.dart';
import '../../graphql/mutation.dart';
import '../../graphql/query.dart';
import '../../providers/accounts.dart';
import '../../theme.dart';
import '../homepage.dart';
import '../login.dart';
import 'addnew_address.dart';
import 'edit_acc.dart';
import 'edit_address.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 80),
          child: accountsBody(context),
        ),
      ),
    );
  }

  Widget accountsBody(BuildContext context) {  
    final AccountsProvider authenticationState = Provider.of<AccountsProvider>(context);
    if (authenticationState.token != null && authenticationState.token.isNotEmpty) {
      return customer(context);
    } else {
      return guest(context);
    }   
  }

  Widget guest(BuildContext context){
    return Column(
      children: [
        Text("Logged in as Guest"),
        ElevatedButton(
          child: Text('Sign in'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          ),
        )
      ],
    );
  }

  Widget customer(BuildContext context){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) => HomePage()
                ),
              );
            },
            child: Text("homepage"),
          ),
          Mutation(
            options: MutationOptions(
            document: gql(revokeToken),
            onCompleted: (data) async {
              final result = data!['revokeCustomerToken']['result'];
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Log out Succeeded!')),
                );
                Provider.of<AccountsProvider>(context, listen: false)
                    .signOff();
                var sharedPref = await SharedPreferences.getInstance();
                await sharedPref.remove('customer');
                // await getCart(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage()),
                  );
              }
            },
            onError: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error.toString()),
                ),
              );
            },
          ),
            builder: (runMutation, result) {
              return ElevatedButton(
                child: Text('Logout'),
                onPressed: () {
                  runMutation({});
                },
              );
            },
          ),
          // SizedBox(height: 20,),
          // SidebarAccount(),
          // SizedBox(height: 10,),
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
              

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 15),
                  //   child: Text(
                  //     'Contact Information',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16
                  //     ),
                  //   )
                  // ),
                  // Container(
                  //   width: context.w,
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     color: colorWhite,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: colorBlack.withOpacity(0.1),
                  //         blurRadius: 10,
                  //           offset: Offset(0,0),
                  //       ),
                  //     ],
                  //     borderRadius: BorderRadius.circular(11)
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text("${cus['firstname']} ${cus['lastname']}"),
                  //       SizedBox(height: 5),
                  //       Text("${cus['email']}"),
                  //       SizedBox(height: 10),
                  //       Wrap(
                  //         spacing: 10,
                  //         children: [
                  //           TextButton(
                  //             onPressed: () {}, 
                  //             child: Text(
                  //               'Edit',
                  //             ),
                  //           ),
                  //           TextButton(
                  //             onPressed: () {
                  //               Navigator.push(
                  //                 context,
                  //                   MaterialPageRoute(builder: (context) => EditAccount()
                  //                 ),
                  //               );
                  //             }, 
                  //             child: Text('Change Password')
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   )
                  // ),
                  
                  // SizedBox(height: 20,),
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
                  showAddress(context, cusAddress),
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
              if (cusOrder.isEmpty) {
                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text("No items")
                );
              } 
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