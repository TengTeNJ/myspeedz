import 'package:flutter/material.dart';
import 'package:my_speedz/chart/battle_speed_stats_line_area_view.dart';
import 'package:my_speedz/chart/switch_view.dart';
import 'package:my_speedz/models/speed_model.dart';
import 'package:my_speedz/utils/navigator_util.dart';
import 'package:vibration/vibration.dart';

import '../constants/constants.dart';
import '../models/battle_speed_model.dart';
import '../utils/data_base.dart';
import '../view/solo_battle_switch_view.dart';
import 'data_bar_view.dart';

enum CurrentMode {
  soloMode,// solo模式
  battleMode // battle模式
}

class SpeedChartController extends StatefulWidget {
  const SpeedChartController({super.key});

  @override
  State<SpeedChartController> createState() => _SpeedChartControllerState();
}

class _SpeedChartControllerState extends State<SpeedChartController> {

  List<SpeedModel> datas = [];
  double maxLeft = 0;
  int maxCount = 0; // 最大进球数

  CurrentMode selectedMode = CurrentMode.soloMode;

  List<BattleSpeedModel> battleDatalist = [];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStorageData();
    getStorageBattleData();

  }


  /// 获取存储的solo 数据
  void getStorageData() async {
    final list = await DataBaseHelper().getData(kDataBaseTableName);
    for (int i = 0 ; i < list.length ; i++) {
      var soloModel = list[i];
      SpeedModel model = SpeedModel("","");
      model.speed = int.parse(soloModel.speedData);
      model.indexString = i.toString();
      model.time = soloModel.time;
      datas.add(model);
      maxLeft =  40;
    }
    setState(() {});
  }
  /// 获取存储的battle 数据
  void getStorageBattleData() async {
    final battleList = await DataBaseHelper().getBattleData(kDataBaseBattleListTableName);
    if (battleList.length > 0) {
      battleDatalist = battleList;
      print("909090${battleList}");
      setState(() {});
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
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 32,left: 24),
                  width: 135,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Constants.actionBGColor,
                  ),
                  child: Center(
                    child: SoloBattleSwitchView(leftTitle: "Solo", rightTitle: "Battle",selectItem: (index){
                      // print('45555${index}');
                      Vibration.vibrate(duration: 500);
                      if (index == 1) { // battle 选项卡
                        selectedMode = CurrentMode.battleMode;
                      } else {
                        selectedMode = CurrentMode.soloMode;
                      }
                      setState(() {});
                    },),
                  ) ,
                ),
              ),
              SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: Constants.screenWidth(context),
                color: Constants.controllerBGColor,
                height: 537 + 40,
                child:
                selectedMode == CurrentMode.soloMode ?
                MyStatsBarChatView(datas: datas,maxLeft: maxLeft + 0.0,maxCount: maxCount,)
                :
                BattleSpeedStatsLineAreaView(datas: battleDatalist, aveDatas: battleDatalist, maxCount: maxCount),
              ),

            ]
        ),
      ),
    );
  }

}
