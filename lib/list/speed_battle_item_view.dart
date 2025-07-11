import 'package:flutter/material.dart';
import 'package:my_speedz/models/battle_speed_model.dart';
import 'package:my_speedz/models/solo_speed_model.dart';
import 'package:my_speedz/utils/blue_tooth_manager.dart';

import '../constants/constants.dart';

class SpeedBattleItemView extends StatefulWidget {
  BattleSpeedModel model;

  SpeedBattleItemView({required this.model});

  @override
  State<SpeedBattleItemView> createState() => _SpeedItemViewState();
}

class _SpeedItemViewState extends State<SpeedBattleItemView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
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

                  Container(
                      child: Image(
                        image: AssetImage('images/home/green_icon.png'),
                        width: 14,
                        height:17,)
                  ),

                  SizedBox(width: 4,),


                  Constants.regularWhiteTextWidget('${widget.model.redName}/${widget.model.greenName}', 16, Colors.white),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(right: 17),
                child:

                // Constants.regularWhiteTextWidget('${widget.model.redSpeedData}/${widget.model.greenSpeedData} Km/h', 16, Colors.white)

                RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    //widget.model.redSpeedData
                    text:"${BluetoothManager().currentSpeedUnit == "Km/h" ?widget.model.redSpeedData
                     : (double.parse(widget.model.redSpeedData) * 0.621371).toStringAsFixed(0)}" ,
                    style: TextStyle(
                      color: Constants.battleListHighTextColor,
                      fontSize: 16,
                      height: 1.8,
                      fontFamily: 'SanFranciscoDisplay',
                      fontWeight: FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '/${BluetoothManager().currentSpeedUnit == "Km/h" ?widget.model.greenSpeedData
                    : (double.parse(widget.model.greenSpeedData) * 0.621371).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontFamily: 'SanFranciscoDisplay',
                          fontSize: 16,
                          color: Constants.grayTextColor,
                          height: 1.8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: ' ${BluetoothManager().currentSpeedUnit}',
                        style: TextStyle(
                          fontFamily: 'SanFranciscoDisplay',
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                    ])),

    ),
          ],

        ),

      ),
    );
  }

}
