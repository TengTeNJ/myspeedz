import 'package:flutter/material.dart';
import 'package:my_speedz/chart/switch_view.dart';
import 'package:my_speedz/models/speed_model.dart';
import 'package:my_speedz/utils/navigator_util.dart';

import '../constants/constants.dart';
import '../view/solo_battle_switch_view.dart';
import 'data_bar_view.dart';

class SpeedChartController extends StatefulWidget {
  const SpeedChartController({super.key});

  @override
  State<SpeedChartController> createState() => _SpeedChartControllerState();
}

class _SpeedChartControllerState extends State<SpeedChartController> {

  List<SpeedModel> datas = [];
  double maxLeft = 0;
  int maxCount = 0; // 最大进球数

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0 ; i < 10 ; i++) {

      SpeedModel model = SpeedModel("","");
      model.speed = 100 + i *10;
      model.indexString = i.toString();
      datas.add(model);
      maxLeft =  40;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkControllerColor,

      body: SingleChildScrollView(
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
                    Constants.boldWhiteTextWidget("Chart", 22),
                    Text('123456')
                  ],
                ),
              ),




              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 32),
                  width: 257,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Constants.actionBGColor,
                  ),
                  child: Center(
                    child: SwitchView(leftTitle: "Solo", rightTitle: "Battle"),
                  ) ,
                ),
              ),


              SizedBox(height: 10,),

              Container(
                margin: EdgeInsets.only(top: 20),
                width: Constants.screenWidth(context),
                color: Constants.controllerBGColor,
                height: 537 + 40,
                child: MyStatsBarChatView(datas: datas,maxLeft: maxLeft + 0.0,maxCount: maxCount,),
              ),

            ]
        ),
      ),
    );
  }

}
