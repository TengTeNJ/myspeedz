import 'package:flutter/material.dart';
import 'package:my_speedz/models/speed_model.dart';

import '../constants/constants.dart';

class SpeedItemView extends StatefulWidget {
  SpeedModel model;

  SpeedItemView({required this.model});

  @override
  State<SpeedItemView> createState() => _SpeedItemViewState();
}

class _SpeedItemViewState extends State<SpeedItemView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // behavior: HitTestBehavior.opaque,
      onTap: (){

      },
      child: Container(
        decoration: BoxDecoration(
          color: Constants.actionBGColor,
          borderRadius: BorderRadius.circular(5),),
        height: 41,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      // margin: EdgeInsets.only(left: 17),
                      child: Image(
                        image: AssetImage('images/home/red_icon.png'),
                        width: 14,
                        height:17,)
                  ),

                  SizedBox(width: 4,),
                  Constants.regularWhiteTextWidget('${widget.model.userName}', 16, Colors.white),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(right: 17),
                child: Constants.regularWhiteTextWidget('${widget.model.speedValue}', 16, Colors.white)
            ),
          ],

        ),

      ),
    );
  }

}
