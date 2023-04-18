import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/footer.dart';
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
import 'manage_address.dart';
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
            HeaderType1(titlePage: "My Account",),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 80),
                  child: accountsBody(context),
                ),
              ),
            ),
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget accountsBody(BuildContext context) {  
    final AccountsProvider authenticationState = Provider.of<AccountsProvider>(context);
    if (authenticationState.token != null && authenticationState.token.isNotEmpty) {
      // print(authenticationState.token);
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
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => HomePage()),
                //   );
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
              var addBilling = (cusAddress.isEmpty)? null: cusAddress.firstWhere((x) => x['default_billing'] == true);
              var addShipping = (cusAddress.isEmpty)? null : cusAddress.firstWhere((x) => x['default_shipping'] == true);
              

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
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                                MaterialPageRoute(builder: (context) => ManageAddress()
                              ),
                            );
                          }, 
                          child: Text('Manage Address')
                        ),
                      ],
                    )
                  ),
                  showAddress(context, cusAddress, addBilling, addShipping),
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

  Widget showAddress(BuildContext context, dynamic cusAddress, dynamic addBilling, dynamic addShipping){
    if (cusAddress.isEmpty) {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Text("No items")
      );
    } 

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
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
                "Default Billing Address",
                style: PrimaryFont.bold(15),
              ),
              SizedBox(height: 5,),
              Text(
                "${addBilling['firstname']} ${addBilling['lastname']}, ${addBilling['street']}, ${addBilling['city']}, ${addBilling['telephone']}"
              ),
              SizedBox(height: 5,),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                      MaterialPageRoute(builder: (context) => EditAddress(idAddress: addBilling['id'])
                    ),
                  );
                }, 
                child: Text('Edit')
              ),
            ],
          )
        ),
        Container(
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
                "Default Shipping  Address",
                style: PrimaryFont.bold(15),
              ),
              SizedBox(height: 5,),
              Text(
                "${addShipping['firstname']} ${addShipping['lastname']}, ${addShipping['street']}, ${addShipping['city']}, ${addShipping['telephone']}"
              ),
              SizedBox(height: 5,),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                      MaterialPageRoute(builder: (context) => EditAddress(idAddress: addShipping['id'])
                    ),
                  );
                }, 
                child: Text('Edit')
              ),
            ],
          )
        ),
      ],
    );
  }

}