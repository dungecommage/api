import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../components/header_type1.dart';
import '../../graphql/mutation.dart';
import '../../graphql/query.dart';
import '../../theme.dart';
import 'manage_address.dart';

class NewAddress extends StatefulWidget {
  const NewAddress({super.key});

  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formValues = {};
  bool _isCheckBilling = false;
  bool _isCheckShipping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "New Address"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                  
                            var cus = result.data!['customer'];
                            List cusAddress = result.data!['customer']['addresses'];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('First Name'),
                                Container(
                                  height: 42,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  child: TextFormField(
                                    initialValue: "${cus['firstname']}",
                                    obscureText: false,
                                    onChanged: (String? val) {
                                      _formValues['firstname'] = val!;
                                    },
                                    onSaved: (String? val) {
                                      _formValues['firstname'] = val!;
                                    },
                                  ),
                                ),
                                Text('Last Name'),
                                Container(
                                  height: 42,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  child: TextFormField(
                                    initialValue: "${cus['lastname']}",
                                    obscureText: false,
                                    onChanged: (String? val) {
                                      _formValues['lastname'] = val!;
                                    },
                                    onSaved: (String? val) {
                                      _formValues['lastname'] = val!;
                                    },
                                  ),
                                ),
                                Text('Phone Number'),
                                Container(
                                  height: 42,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  child: TextFormField(
                                    obscureText: false,
                                    onChanged: (String? val) {
                                      _formValues['telephone'] = val!;
                                    },
                                    onSaved: (String? val) {
                                      _formValues['telephone'] = val!;
                                    },
                                  ),
                                ),
                                Text('Street Address'),
                                Container(
                                  height: 42,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  child: TextFormField(
                                    obscureText: false,
                                    onChanged: (String? val) {
                                      _formValues['street'] = val!;
                                    },
                                    onSaved: (String? val) {
                                      _formValues['street'] = val!;
                                    },
                                  ),
                                ),
                                Text('City '),
                                Container(
                                  height: 42,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  child: TextFormField(
                                    onChanged: (String? valCity) {
                                      _formValues['city'] = valCity!;
                                    },
                                    onSaved: (String? valCity) {
                                      _formValues['city'] = valCity!;
                                    },
                                  ),
                                ),
                                Text('Post Code'),
                                Container(
                                  height: 42,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  child: TextFormField(
                                    onChanged: (String? valPostcode) {
                                      _formValues['postcode'] = valPostcode!;
                                    },
                                    onSaved: (String? valPostcode) {
                                      _formValues['postcode'] = valPostcode!;
                                    },
                                  ),
                                ),
                                (cusAddress.isEmpty)?
                                Container() :
                                Column(
                                  children: [
                                    CheckboxListTile(
                                      controlAffinity: ListTileControlAffinity.leading,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text('Use as my default billing address'),
                                      activeColor: colorTheme,
                                      value: _isCheckBilling,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isCheckBilling = !_isCheckBilling;
                                        });
                                      }
                                    ),
                                    CheckboxListTile(
                                      controlAffinity: ListTileControlAffinity.leading,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text('Use as my default shipping address'),
                                      activeColor: colorTheme,
                                      value: _isCheckShipping,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isCheckShipping = !_isCheckShipping;
                                        });
                                      }
                                    ),
                                  ],
                                ),                                
                                Mutation(
                                  options: MutationOptions(
                                    document: gql(createCustomerAddress),
                                    onCompleted: (data) async {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("You saved the address."),
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ManageAddress()),
                                      );
                                    },
                                    onError: (error) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(error.toString()),
                                        ),
                                      );
                                      print(error.toString());
                                    },
                                  ),
                                  builder: (runMutation, result) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        var fName = (_formValues['firstname'] == null)? "${cus['firstname']}" : _formValues['firstname'];
                                        var lName = (_formValues['lastname'] == null)? "${cus['lastname']}" : _formValues['lastname'];
                                        bool dBilling = (cusAddress.isEmpty)? true : _isCheckBilling;
                                        bool dShipping = (cusAddress.isEmpty)? true : _isCheckShipping;
                                        runMutation({
                                          'country_code': "VN",
                                          'firstname': fName,
                                          'lastname': lName,
                                          'telephone': _formValues['telephone'],
                                          'street': _formValues['street'],
                                          'city': _formValues['city'],
                                          'postcode': _formValues['postcode'],
                                          'default_billing': dBilling,
                                          'default_shipping': dShipping
                                        });
                                      },
                                      child: Text("Save"),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size.fromHeight(42)
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                        )
                      ]
                    ),
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}