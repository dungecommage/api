

import 'package:connect_api/components/header_type1.dart';
import 'package:connect_api/theme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email'),
                        Container(
                          height: 42,
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          decoration: BoxDecoration(
                            color: colorGreyBg,
                            borderRadius: BorderRadius.circular(11)
                          ),
                          child: TextFormField(
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0, color: Colors.transparent)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0, color: Colors.transparent),
                            ),
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                            ),
                          ),
                        ),
                        Text('Password'),
                        Container(
                          height: 42,
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          decoration: BoxDecoration(
                            color: colorGreyBg,
                            borderRadius: BorderRadius.circular(11)
                          ),
                          child: TextFormField(
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0, color: Colors.transparent)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0, color: Colors.transparent),
                            ),
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {}, 
                          child: Text('Login'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(42),
                          )
                        ),
                         
                      ],
                    )
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