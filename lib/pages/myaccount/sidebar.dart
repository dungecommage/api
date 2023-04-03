import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme.dart';
import 'acc_address.dart';
import 'acc_dashboard.dart';

class SidebarAccount extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccAddress()),
          ),
          child: ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            shape: Border(
              bottom: BorderSide(color: colorGreyBorder)
            ),
            title: Text(
              "Address Book",
            ),
            trailing: Icon(
              FontAwesomeIcons.angleRight,
              color: colorBlack,
              size: 14,
            )
          ),
        ),
      ],
    );
  }
}
