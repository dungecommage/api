

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/header_type1.dart';
import '../graphql/mutation.dart';
import '../providers/accounts.dart';
import '../theme.dart';
import 'myaccount/acc_dashboard.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Create account"),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('First Name'),
                      Container(
                        height: 42,
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: TextFormField(
                          onChanged: (String? valFname) {
                            _formValues['firstname'] = valFname!;
                          },
                          onSaved: (String? valFname) {
                            _formValues['firstname'] = valFname!;
                          },
                        ),
                      ),
                      Text('Last Name'),
                      Container(
                        height: 42,
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: TextFormField(
                          onChanged: (String? valLname) {
                            _formValues['lastname'] = valLname!;
                          },
                          onSaved: (String? valLname) {
                            _formValues['lastname'] = valLname!;
                          },
                        ),
                      ),
                      Text('Email'),
                      Container(
                        height: 42,
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: TextFormField(
                          obscureText: false,
                          onChanged: (String? valEmail) {
                            _formValues['email'] = valEmail!;
                          },
                          onSaved: (String? valEmail) {
                            _formValues['email'] = valEmail!;
                          },
                        ),
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
                      Text('Confirm Password'),
                      Container(
                        height: 42,
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: TextFormField(
                          obscureText: false,
                          onChanged: (String? valCfPw) {
                            _formValues['confirmPassword'] = valCfPw!;
                          },
                          onSaved: (String? valCfPw) {
                            _formValues['confirmPassword'] = valCfPw!;
                          },
                        ),
                      ),
                      
                      Mutation(
                        options: MutationOptions(
                          document: gql(createAcc),
                          onCompleted: (data) async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Create Account Succeeded!')),
                            );
                            var token;
                            final AccountsProvider authenticationState = Provider.of<AccountsProvider>(context);
                            Provider.of<AccountsProvider>(context, listen: false)
                            .signIn(token);
                            var sharedPref = await SharedPreferences.getInstance();
                            await sharedPref.setString('customer', token);
                            // await getCart(context);
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
                          },
                        ), 
                        builder: (runMutation, result) {
                          return ElevatedButton(
                            onPressed: () {
                              if(_formValues['password'] == _formValues['confirmPassword']){
                                runMutation({
                                  'firstname': _formValues['firstname'],
                                  'lastname': _formValues['lastname'],
                                  'email': _formValues['email'],
                                  'pass': _formValues['password'],
                                });
                              } else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please enter Password & Confirm Password the same value again."),
                                  ),
                                );
                              }
                            },
                            child: Text('Create an Account'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(42)
                            ),
                          );
                        }
                      )
                    ],
                
                  ),
                ),
              ),
            )
          ]
        )
      )
    );
  }
}