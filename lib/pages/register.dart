

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../components/header_type1.dart';
import '../theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formValues = {};

  final String createAcc = '''
    mutation CreateCustomerMutation(
      \$firstname: String!,
      \$lastname: String!,
      \$email: String!, 
      \$pass: String!
    ) {
      createCustomer(
        input: {
          firstname: \$firstname
          lastname: \$lastname
          email: \$email
          password: \$pass
          is_subscribed: true
        }
      ){
        customer{
          firstname
          lastname
          email
          is_subscribed
        }
      }
    }
  ''';

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
                            if (data == null) {
                              return;
                            }
                            final createCustomer = data['createCustomer'];
                            if (createCustomer == null) {
                              return;
                            }
                            
                            Navigator.pop(context);
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
                              runMutation({
                                'firstname': _formValues['firstname'],
                                'lastname': _formValues['lastname'],
                                'email': _formValues['email'],
                                'pass': _formValues['password'],
                              });

                              if(_formValues['password'] == _formValues['confirmPassword']){
                                print('Pw correct!');
                              } else{
                                print('Pw incorrect');
                              }
                              print(_formValues['firstname']);
                              print(_formValues['lastname']);
                              print(_formValues['email']);
                              print(_formValues['password']);
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