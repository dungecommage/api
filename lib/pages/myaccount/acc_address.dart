import 'package:flutter/material.dart';

import '../../components/header_type1.dart';

class AccAddress extends StatelessWidget {
  const AccAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Address Book"),
            Text('Add list')
          ],
        ),
      ),
    );
  }
}