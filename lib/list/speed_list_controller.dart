import 'package:flutter/material.dart';
import 'package:my_speedz/list/speed_battle_list_view.dart';
import 'package:my_speedz/list/speed_list_view.dart';
import 'package:my_speedz/models/battle_speed_model.dart';
import 'package:my_speedz/models/solo_speed_model.dart';
import 'package:my_speedz/models/speed_model.dart';
import 'package:my_speedz/view/solo_battle_switch_view.dart';
import 'package:vibration/vibration.dart';

import '../constants/constants.dart';
import '../utils/data_base.dart';
import '../utils/navigator_util.dart';

enum CurrentMode {
  soloMode,// solo模式
  battleMode // battle模式
}

class SpeedListController extends StatefulWidget {
  const SpeedListController({super.key});

  @override
  State<SpeedListController> createState() => _SpeedListControllerState();
}

class _SpeedListControllerState extends State<SpeedListController> {
  List<SoloSpeedModel> datalist = [];
  List<BattleSpeedModel> battleDatalist = [];

  CurrentMode selectedMode = CurrentMode.soloMode;


  /// 获取存储的solo数据
  void getStorageData() async {
    final list = await DataBaseHelper().getData(kDataBaseTableName);
    if (list.length > 0) {
      datalist = list;
      setState(() {});
    }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getStorageData();
    getStorageBattleData();
  }
  
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
                    child: SoloBattleSwitchView(leftTitle: "Solo", rightTitle: "Battle",selectItem: (index){
                       print('45555${index}');
                       if (index == 1) { // battle 选项卡
                         selectedMode = CurrentMode.battleMode;
                       } else {
                         selectedMode = CurrentMode.soloMode;
                       }
                       setState(() {

                       });
                    },),
                  ),

                  GestureDetector(onTap: (){
                     print("排序");
                     if (selectedMode == CurrentMode.soloMode) {
                       datalist.sort((a,b) =>  int.parse(b.speedData).compareTo(int.parse(a.speedData)));
                       setState(() {});
                       Vibration.vibrate(duration: 500);
                     }

                  },
                  child: Container(
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
                  ),


                ],
              ),
            ),



              /// List View
              Container(
                margin: EdgeInsets.only(left: 24,right: 24,top: 0),
                height: Constants.screenHeight(context) -200,
                child: selectedMode == CurrentMode.battleMode ? SpeedBattleListView(datas: battleDatalist)
                : SpeedListView(datas: datalist),
              ),
              SizedBox(height: 10,),

            ]
        ),
      ),
    );
  }
}
