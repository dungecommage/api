import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme.dart';

class FormActions extends StatefulWidget {
  const FormActions({super.key});

  @override
  State<FormActions> createState() => _FormActionsState();
}

class _FormActionsState extends State<FormActions> {
  int value = 1;
  // final myController = TextEditingController();
   @override
  void initState() {
    super.initState();
    final String _value = value.toString();
  }

  void toggleIncrease() {
    setState(() {
      value++;
    });
  }
  void toggleDecrease() {
    (value == 1)? 1 : setState(() {
      value--;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: InkWell(
            onTap: () {
              toggleDecrease();
              print(value);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: colorGreyBg,
                borderRadius: BorderRadiusDirectional.circular(4)
              ),
              child: Icon(
                FontAwesomeIcons.minus,
                size: 14,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 6,
          child: Container(
            height: 30,
            child: TextFormField(
              // controller: myController,
              key: Key('${value}'),
              initialValue: '${value}',
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
              )
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: InkWell(
            onTap: () {
              toggleIncrease();
              print(value);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(4),
                color: colorGreyBg,
              ),
              child: Icon(
                FontAwesomeIcons.plus,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}