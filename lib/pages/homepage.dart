import 'package:connect_api/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../components/header_type1.dart';
import '../providers/accounts.dart';
import 'category.dart';
import 'home/sub-cate.dart';
import 'login.dart';
import 'register.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
    );
  }
}
