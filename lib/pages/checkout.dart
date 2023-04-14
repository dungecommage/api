

import 'package:flutter/material.dart';

import '../components/footer.dart';
import '../components/header_type1.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Shopping Cart",),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Text("Checkout"),
                ),
              )
            ),
            Footer(),
          ],
        ),
      ),
    );
  }
}