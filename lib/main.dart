

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'pages/category.dart';
import 'pages/homepage.dart';
import 'pages/login.dart';
import 'pages/myaccount/acc_dashboard.dart';
import 'pages/product.dart';
import 'providers/accounts.dart';
import 'providers/cart.dart';
import 'theme.dart';

void main() => runApp(
  MyHome()
);

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Link link;
    HttpLink httpLink  = HttpLink("https://flutter.ecommage.com/graphql");

    final provider = context.watch<AccountsProvider>();
    if (provider.isCustomer) {
      final authLink = AuthLink(getToken: () => 'Bearer ${provider.token}');
      link = authLink.concat(httpLink);
    } else {
      link = httpLink;
    }

    var qlClient = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link, 
        cache: GraphQLCache()
      )
    );

    return GraphQLProvider(
      client: qlClient,
      child: CacheProvider(
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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
                // foregroundColor: colorBlack
              )
            ), 
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
                foregroundColor: colorBlack,
              )
            )
          ),
          debugShowCheckedModeBanner: false,
          // home: HomePage(),
          home: ProductPage(sku: "WJ12",),
        ),
      ),
    );
  }
}