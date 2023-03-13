

import 'package:flutter/material.dart';

import '../theme.dart';

class AlertDialogTitle extends StatelessWidget {
  final String data;
  const AlertDialogTitle({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              data,
              style: PrimaryFont.bold(18),
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            width: 30,
            height: 30,
            child: InkWell(
              onTap:  () => Navigator.pop(context, 'Cancel'),
              child: Icon(Icons.close)
            ),
          ),
        ],
      ),
    );
  }
}