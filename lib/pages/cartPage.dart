

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../components/header_type1.dart';
import '../grapql/query.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "Checkout cart"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Query(
                      options: QueryOptions(
                        document: gql(customerCart)
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

                        return Container();
                      }
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}