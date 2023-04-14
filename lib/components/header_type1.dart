
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/cartPage.dart';
import '../theme.dart';

class HeaderType1 extends StatelessWidget {
  final String titlePage;
  HeaderType1({
    Key? key,
    required this.titlePage
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
      height: 60,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            // child: Icon(Icons.arrow_back_ios)
            child: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
          ),
          Flexible(
            flex: 8,
            fit: FlexFit.tight,
            child: Text(
              titlePage, 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            )
          ),
          Flexible(
            flex: 1,
            // child: Icon(Icons.arrow_back_ios)
            child: Stack(
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                        MaterialPageRoute(builder: (context) => CartPage()
                      ),
                    );
                    
                  },
                  icon: Icon(
                    FontAwesomeIcons.shoppingBag
                  ),
                ),
                // Positioned(
                //   top: 0,
                //   right: 0,
                //   child: Container(
                //     width: 16,
                //     height: 16,
                //     decoration: BoxDecoration(
                //       color: colorBlack,
                //       borderRadius: BorderRadius.circular(8)
                //     ),
                //     child: Align(
                //       alignment: Alignment.center,
                //       child: Text(
                //         '0',
                //         style: TextStyle(
                //           color: colorWhite,
                //           fontSize: 11
                //         ),
                //       )
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}