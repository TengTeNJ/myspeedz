import 'package:flutter/material.dart';
import 'package:my_speedz/models/speed_model.dart';

import '../constants/constants.dart';


class MyStatsTipView extends StatefulWidget {
  SpeedModel dataModel;
  MyStatsTipView({required this.dataModel});


  @override
  State<MyStatsTipView> createState() => _MyStatsTipViewState();
}

class _MyStatsTipViewState extends State<MyStatsTipView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(62, 62, 85, 1)),
      width: 60,
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(left: 4, top: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image(image: AssetImage('images/home/red_icon.png'),width:8 ,height: 8,),
            Constants.customTextWidget('${widget.dataModel.speed}', 20, '#E96415',fontWeight:FontWeight.w700),
            // Constants.customTextWidget('${StringUtil.stringToEnglishDate(widget.dataModel.gameTimer)}', 10, '#B1B1B1'),
            SizedBox(height: 4,)
          ],
        ),
      ),
    );
  }
}
