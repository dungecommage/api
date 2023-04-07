import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../components/header_type1.dart';
import '../../graphql/mutation.dart';
import '../../graphql/query.dart';
import 'acc_dashboard.dart';

class EditAccount extends StatelessWidget {
  EditAccount({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Change Password",),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('First Name'),
                                Container(
                                  height: 42,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  child: TextFormField(
                                    obscureText: false,
                                    controller: TextEditingController(text: "${cus['firstname']}"),
                                    onChanged: (String? valFname) {
                                      _formValues['fname'] = valFname!;
                                    },
                                    onSaved: (String? valFname) {
                                      _formValues['fname'] = valFname!;
                                    },
                                  ),
                                ),
                                Text('Last Name'),
                                Container(
                                  height: 42,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  child: TextFormField(
                                    obscureText: false,
                                    controller: TextEditingController(text: "${cus['lastname']}"),
                                    onChanged: (String? valLname) {
                                      _formValues['lname'] = valLname!;
                                    },
                                    onSaved: (String? valLname) {
                                      _formValues['lname'] = valLname!;
                                    },
                                  ),
                                ),
                                Text('Email'),
                                Container(
                                  height: 42,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  child: TextFormField(
                                    obscureText: false,
                                    controller: TextEditingController(text: "${cus['email']}"),
                                    onChanged: (String? valEmail) {
                                      _formValues['email'] = valEmail!;
                                    },
                                    onSaved: (String? valEmail) {
                                      _formValues['email'] = valEmail!;
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                        Text('Password'),
                        Container(
                          height: 42,
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          child: TextFormField(
                            obscureText: false,
                            onChanged: (String? valPw) {
                              _formValues['password'] = valPw!;
                            },
                            onSaved: (String? valPw) {
                              _formValues['password'] = valPw!;
                            },
                          ),
                        ),
                        Text('New Password'),
                        Container(
                          height: 42,
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          child: TextFormField(
                            obscureText: false,
                            onChanged: (String? valNewPw) {
                              _formValues['npassword'] = valNewPw!;
                            },
                            onSaved: (String? valNewPw) {
                              _formValues['npassword'] = valNewPw!;
                            },
                          ),
                        ),
                        Text('Confirm New Password'),
                        Container(
                          height: 42,
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          child: TextFormField(
                            obscureText: false,
                            onChanged: (String? valCNewPw) {
                              _formValues['cnpassword'] = valCNewPw!;
                            },
                            onSaved: (String? valCNewPw) {
                              _formValues['cnpassword'] = valCNewPw!;
                            },
                          ),
                        ),
                        
                        Mutation(
                            options: MutationOptions(
                              document: gql(changeCustomerPassword),
                              onCompleted: (data) async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Save Info Succeeded!')),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccDashBoard()),
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
                                child: Text('Save'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size.fromHeight(40),
                                ),
                                onPressed: () {
                                  if(_formValues['npassword'] == _formValues['cnpassword']){
                                    runMutation({
                                      'pass': _formValues['password'],
                                      'npass': _formValues['npassword'],
                                    });
                                  }
                                  
                                },
                              );
                            },
                          ),
                      ],
                    ),
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