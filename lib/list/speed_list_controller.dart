import 'package:flutter/material.dart';
import 'package:my_speedz/list/speed_list_view.dart';
import 'package:my_speedz/models/speed_model.dart';
import 'package:my_speedz/view/solo_battle_switch_view.dart';

import '../constants/constants.dart';
import '../utils/navigator_util.dart';
class SpeedListController extends StatefulWidget {
  const SpeedListController({super.key});

  @override
  State<SpeedListController> createState() => _SpeedListControllerState();
}

class _SpeedListControllerState extends State<SpeedListController> {
  List<SpeedModel> data = [
    SpeedModel('Default','80 Km/h'),
    SpeedModel('Default','80 Km/h'),
    SpeedModel('Default','80 Km/h'),
    SpeedModel('Default','80 Km/h'),
    SpeedModel('Default','80 Km/h'),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.darkControllerColor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Constants.screenWidth(context),
                margin: EdgeInsets.only(top: 55,left: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(onTap: (){
                      NavigatorUtil.pop();

                    },
                      child: Container(
                        //  padding: EdgeInsets.all(12.0),
                        padding: EdgeInsets.only(left: 0,top: 12,bottom: 12,right: 24),
                        color:  Constants.darkControllerColor,
                        width: 48,
                        height: 48,
                        child: Image(
                          fit: BoxFit.contain,
                          width:10.34,
                          height: 19.51,
                          image: AssetImage('images/home/back_icon.png'),
                        ),
                      ),
                    ),


                    Constants.boldWhiteTextWidget("List", 22),
                    Text('123456')
                  ],
                ),
              ),



            Container(
              margin: EdgeInsets.only(top: 24),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 24),
                    width: 138,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Constants.actionBGColor,
                    ),
                    child: SoloBattleSwitchView(leftTitle: "Solo", rightTitle: "Battle"),
                  ),

                  Container(
                    padding: EdgeInsets.only(right: 24),
                    color:  Constants.darkControllerColor,
                    // width: 48,
                    // height: 48,
                    child: Image(
                      fit: BoxFit.fitWidth,
                      width:16.85,
                      height: 19.72,
                      image: AssetImage('images/home/sort_icon.png'),
                    ),
                  ),

                ],
              ),
            ),



              Container(
                margin: EdgeInsets.only(left: 24,right: 24,top: 0),
                height: Constants.screenHeight(context) -200,
                child: SpeedListView(datas: data),
              ),
              SizedBox(height: 10,),

            ]
        ),
      ),
    );
  }
}
