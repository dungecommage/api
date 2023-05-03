

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/footer.dart';
import '../../components/header_type1.dart';
import '../../components/product_item.dart';
import '../../graphql/query.dart';
import '../../providers/accounts.dart';
import '../../theme.dart';
import '../login.dart';

class AccountWishlist extends StatefulWidget {
  const AccountWishlist({super.key});

  @override
  State<AccountWishlist> createState() => _AccountWishlistState();
}

class _AccountWishlistState extends State<AccountWishlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderType1(titlePage: "My Wishlist"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: wishlistContent(context),
                )
              )
            ),
            Footer(),
          ]
        )
      )
    );
  }

  Widget wishlistContent(BuildContext context){
    final AccountsProvider authenticationState = Provider.of<AccountsProvider>(context);
    if (authenticationState.token != null && authenticationState.token.isNotEmpty) {
      return customerWishlist(context);
    } else {
      return guestWishlist(context);
    } 
  }

  Widget guestWishlist(BuildContext context){
    return Column(
      children: [
        Text("Logged in as Guest"),
        ElevatedButton(
          child: Text('Sign in'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          ),
        )
      ],
    );
  }

  Widget customerWishlist(BuildContext context){
    return Query(
      options: QueryOptions(
        document: gql(wishlist),
        fetchPolicy: FetchPolicy.noCache,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
      ), 
      builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }
    
        if (result.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final wl = result.data!['customer']['wishlist'];
        final items = wl['items'];
        return AlignedGridView.count(
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          shrinkWrap: true,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          crossAxisCount: 2,
            itemBuilder: (context, index) {
              final item = items[index]['product'];
              return productBox(
                context,
                item,
              );
            },
          );
  }
    );
  }
}