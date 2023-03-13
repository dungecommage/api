

import 'dart:io';

import 'package:connect_api/theme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'pages/category.dart';
import 'pages/homepage.dart';
import 'pages/product.dart';

void main() => runApp(
  const MyApp(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // HttpLink link = HttpLink("https://rickandmortyapi.com/graphql");
    HttpLink link = HttpLink("https://flutter.ecommage.com/graphql");
    var qlClient = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link, 
        cache: GraphQLCache()
      )
    );

    return GraphQLProvider(
      client: qlClient,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: colorTheme,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorTheme,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11)
              ),
              // minimumSize: Size.fromHeight(40),
            )
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}