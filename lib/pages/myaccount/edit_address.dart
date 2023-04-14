

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../components/header_type1.dart';
import '../../graphql/mutation.dart';
import '../../graphql/query.dart';
import '../../theme.dart';
import 'manage_address.dart';
import 'acc_dashboard.dart';

class EditAddress extends StatefulWidget {
  int idAddress;
  EditAddress({
    Key? key,
    required this.idAddress
  }) : super(key: key);

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  bool _isCheckBilling = false;
  bool _isCheckShipping = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Edit Address"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
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

                            List cusAddress = result.data!['customer']['addresses'];
                            var address = cusAddress.firstWhere((x) => x['id'] == widget.idAddress);
                            bool billing = address['default_billing'];
                            bool shipping = address['default_shipping'];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [    
                                Text('Street Address'),
                                Container(
                                  height: 42,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  child: TextFormField(
                                    initialValue: "${address['street']}",
                                    obscureText: false,
                                    // controller: TextEditingController(
                                    //   text: "${address['street']}"
                                    // ),
                                    onChanged: (String? valStreet) {
                                      _formValues['street'] = valStreet!;
                                    },
                                    onSaved: (String? valStreet) {
                                      _formValues['street'] = valStreet!;
                                    },
                                  ),
                                ),
                                Text('City '),
                                Container(
                                  height: 42,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  child: TextFormField(
                                    // controller: TextEditingController(
                                    //   text: "${address['city']}"
                                    // ),
                                    initialValue: "${address['city']}",
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
                                    initialValue: "${address['postcode']}",
                                    onChanged: (String? valPostcode) {
                                      _formValues['postcode'] = valPostcode!;
                                    },
                                    onSaved: (String? valPostcode) {
                                      _formValues['postcode'] = valPostcode!;
                                    },
                                  ),
                                ),
                                (billing == true)?
                                Container(
                                  color: colorbgWarning,
                                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                                  width: context.w,
                                  child: Text("It's a default billing address."),
                                ) :
                                CheckboxListTile(
                                  controlAffinity: ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('Use as my default billing address'),
                                  activeColor: colorTheme,
                                  value: _isCheckBilling,
                                  onChanged: (value) {  
                                    setState(() {
                                      _isCheckBilling = !_isCheckBilling;
                                    });
                                  },
                                ),
                                (shipping == true)?
                                Container(
                                  color: colorbgWarning,
                                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: context.w,
                                  child: Text("It's a default shipping address."),
                                ) :
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
                                Mutation(
                                  options: MutationOptions(
                                    document: gql(updateCustomerAddress),
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
                                        var street = (_formValues['street'] == null)? "${address['street']}" : _formValues['street'];
                                        var city = (_formValues['city'] == null)? "${address['city']}" : _formValues['city'];
                                        var postcode = (_formValues['postcode'] == null)? "${address['postcode']}" : _formValues['postcode'];
                                        bool valBilling = (billing == true)? true : _isCheckBilling;
                                        bool valShipping = (shipping == true)? true : _isCheckShipping;
                                        runMutation({
                                          'id': widget.idAddress,
                                          'street': street,
                                          'city': city,
                                          'postcode': postcode,
                                          'default_billing': valBilling,
                                          'default_shipping': valShipping
                                        });
                                      },
                                      child: Text('Save'),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size.fromHeight(42)
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                        ),
                        
                        
                        
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