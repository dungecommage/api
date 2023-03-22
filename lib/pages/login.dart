import 'package:connect_api/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/header_type1.dart';
import '../providers/accounts.dart';
import '../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formValues = {};

  final String createToken = '''
    mutation CreateCustomerToken(\$email: String!, \$pass: String!) {
      generateCustomerToken(
        email: \$email
        password: \$pass
      ) {
        token
      }
    }
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Login"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email'),
                          Container(
                            height: 42,
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            decoration: BoxDecoration(
                                color: colorGreyBg,
                                borderRadius: BorderRadius.circular(11)),
                            child: TextFormField(
                              obscureText: false,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, color: Colors.transparent),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                              ),
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
                            decoration: BoxDecoration(
                                color: colorGreyBg,
                                borderRadius: BorderRadius.circular(11)),
                            child: TextFormField(
                              obscureText: false,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, color: Colors.transparent),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                              ),
                              onChanged: (String? valPw) {
                                _formValues['password'] = valPw!;
                              },
                              onSaved: (String? valPw) {
                                _formValues['password'] = valPw!;
                              },
                            ),
                          ),
                          Mutation(
                            options: MutationOptions(
                              document: gql(createToken),
                              onCompleted: (data) async {
                                if (data == null) {
                                  return;
                                }
                                final generateToken = data['generateCustomerToken'];
                                if (generateToken == null) {
                                  return;
                                }
                                final token = generateToken['token'];
                                Provider.of<AccountsProvider>(context,listen: false).signIn(token);
                                var sharedPref = await SharedPreferences.getInstance();
                                await sharedPref.setString('customer', token);
                                // await getCart(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                                // Navigator.pop(context);
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
                                child: Text('Login'),
                                onPressed: () {
                                  // if (!_formKey.currentState!.validate()) {
                                  //   _formKey.currentState!
                                  //       .save();

                                  
                                  // }
                                  if(validateAndSave()){
                                    runMutation({
                                      'email': _formValues['email'],
                                      'pass': _formValues['password'],
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave(){
    final form = _formKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    return false;
  }
}