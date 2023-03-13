import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../components/modal_title.dart';
import '../../components/page_subtitle.dart';
import '../../theme.dart';

Widget productDescription(BuildContext context, dynamic item) {
  var desPr = item['description']['html'];
  if (desPr.isEmpty) {
    return Container();
  } 
  else {
    return Column(
      children: [
        Container(
          child: Subtitle(title: 'Chi tiết sản phẩm')
        ),
        ClipRect(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 300
            ),
            child: Html(
              data: desPr,
            ),
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: context.w,
                      color: colorWhite,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          AlertDialogTitle(data: 'Thông tin chi tiết'),
                          Container(
                            height: context.h * 0.8,
                            child: SingleChildScrollView(
                              child: Html(
                                data: desPr,
                              ),
                            )
                          )
                        ],
                      )
                    ), 
                  ],
                ),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: colorTheme)
                ),
                child: Text(
                  'Xem thêm',
                  style: TextStyle(
                    color: colorTheme,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
  
}