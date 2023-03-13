import 'package:flutter/material.dart';

import '../theme.dart';

class Subtitle extends StatelessWidget {
  String title;

  Subtitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorTheme
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}