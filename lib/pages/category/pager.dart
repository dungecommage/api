

import 'package:flutter/material.dart';

import '../../theme.dart';

class Pager extends StatefulWidget {
  dynamic item;
  Pager({
    Key? key,
    this.item
  });

  @override
  State<Pager> createState() => _PagerState();
}

class _PagerState extends State<Pager> {
  int? count;
  int? pageSize;
  int? currentPage;
  int? countpage;
  int? pager;
  @override
  void initState() {
    super.initState();
    count = widget.item['total_count'];
    pageSize = widget.item['page_info']['page_size'];
    currentPage = widget.item['page_info']['current_page'];
    countpage = (count! / pageSize!).ceil();
  }

  void changePage(){
    setState(() {
      currentPage = pager;
    });
  }

  @override
  Widget build(BuildContext context) {    
    return Column(
      children: [
        // Text('${count}'),
        Text('${currentPage}'),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            (count == 0)? "Can't find product" : "${count.toString()} items"
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(countpage!, (int i){
            var pager = i+1;
            return InkWell(
              onTap: () {
                setState(() {
                  currentPage = pager;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: (currentPage == pager)? colorTheme : colorGreyBg,
                  borderRadius: BorderRadius.circular(4)
                ),
                margin: EdgeInsets.symmetric(horizontal: 3),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  '${pager}',
                  style: TextStyle(
                    color: (currentPage == pager)? colorWhite : colorBlack
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}