import 'package:connect_api/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../components/header_type1.dart';
import 'category.dart';
import 'home/sub-cate.dart';
import 'login.dart';
import 'register.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(
              titlePage: "Homepage",
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      SubCateHome(),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () { 
                              Navigator.push(
                                context,
                                  MaterialPageRoute(builder: (context) => LoginPage()
                                ),
                              );
                            }, 
                            child: Text('Login')
                          ),
                          OutlinedButton(
                            onPressed: () { 
                              Navigator.push(
                                context,
                                  MaterialPageRoute(builder: (context) => RegisterPage()
                                ),
                              );
                            }, 
                            child: Text('Create account')
                          ),
                        ],
                      )
                    ],
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
