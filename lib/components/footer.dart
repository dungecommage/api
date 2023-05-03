

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/cartPage.dart';
import '../pages/category.dart';
import '../pages/homepage.dart';
import '../pages/myaccount/acc_dashboard.dart';
import '../pages/myaccount/acc_wishlist.dart';
import '../theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: colorWhite,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.1),
             blurRadius: 10,
              offset: Offset(0,0),
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => HomePage()
                  ),
                );
              },
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.home,
                    size: 18,
                  ),
                  Text("Home")
                ],
              ),
            )
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => CategoryPage(categoryId: 3,)
                  ),
                );
              },
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.list,
                    size: 18,
                  ),
                  Text("Category")
                ],
              ),
            )
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => AccountWishlist()
                  ),
                );
              },
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.heart,
                    size: 18,
                  ),
                  Text("Wishlist")
                ],
              ),
            )
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => CartPage()
                  ),
                );
              },
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.shoppingBag,
                    size: 18,
                  ),
                  Text("Cart")
                ],
              ),
            )
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => AccDashBoard()
                  ),
                );
              },
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.user,
                    size: 18,
                  ),
                  Text("Account")
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}