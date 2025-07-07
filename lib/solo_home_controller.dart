import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_speedz/models/battle_speed_model.dart';
import 'package:my_speedz/models/solo_speed_model.dart';
import 'package:my_speedz/routes/routes.dart';
import 'package:my_speedz/utils/ble_util.dart';
import 'package:my_speedz/utils/blue_tooth_manager.dart';
import 'package:my_speedz/utils/data_base.dart';
import 'package:my_speedz/utils/dialog.dart';
import 'package:my_speedz/utils/navigator_util.dart';
import 'package:my_speedz/utils/speedz_manager.dart';

import 'circle_progress_widget.dart';
import 'constants/constants.dart';

enum CurrentMode {
  soloMode,// solo模式
  battleMode // battle模式
}


class SoloHomeController extends StatefulWidget {
  const SoloHomeController({super.key});

  @override
  State<SoloHomeController> createState() => _SoloHomeControllerState();
}

class _SoloHomeControllerState extends State<SoloHomeController> {
  double progress = 0;
  double currentSpeedValue = 0; // solo 模式下的数据
  CurrentMode selectedMode = CurrentMode.soloMode;
  Timer? _timer;
  List battleSpeedValue = [];// battle 数据 （只存两个数据）
  double redcalculateSpeed = 0;//battle 模式下红色的数据
  double greencalculateSpeed = 0;//battle 模式下蓝色的数据

  Color indicatorColor = Constants.grayIndicatirColor; /// 指示灯的颜色
  BattleSpeedModel recentlyBattleModel = BattleSpeedModel(redSpeedData: "0",
      greenSpeedData: "0",
      redName: "Default 1", greenName:
      "Default 2");
  SoloSpeedModel recentlySoloModel = SoloSpeedModel(speedData: "0", name: "Default 1");



 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedMode = CurrentMode.soloMode;

    BluetoothManager();
    // 扫描蓝牙设备
    Future.delayed(Duration(milliseconds: 1000),(){
    // BluetoothManager().startNewScan();
       BleUtil.begainScan(context);

    });

    BluetoothManager().dataChange = (measureSpeed) {
      print("666测量到的速度${measureSpeed}");
      measuredSoeedAnimation(measureSpeed);
      if (selectedMode == CurrentMode.soloMode) {
        soloDataStorage(measureSpeed);
        indicatorColor = Constants.grayIndicatirColor;
      } else {
        battleSpeedValue.add(measureSpeed);
        if (battleSpeedValue.length == 2) {
          indicatorColor = Constants.greenIndicatirColor;
          greencalculateSpeed = measureSpeed.toDouble();
          battleDataStorage(); // 保存该轮比赛下双方的数据
        } else {
          indicatorColor = Constants.redIndicatirColor;
          redcalculateSpeed = measureSpeed.toDouble();
          greencalculateSpeed = 0;// 清空上一轮的蓝方的数据
        }
        setState(() {});
      }
    };

    getStorageSoloData();
    getStorageBattleData();
  }

  /// solo数据存储
  void soloDataStorage(int speed) {
    var model = SoloSpeedModel(speedData: speed.toString(), name: "Default 1");
    DataBaseHelper().insertData(kDataBaseTableName, model);
  }

  /// battle数据存储
  void battleDataStorage() {
    if (battleSpeedValue.length == 2) {
      var model = BattleSpeedModel(redSpeedData: battleSpeedValue[0].toString(),
          greenSpeedData: battleSpeedValue[1].toString(),
          redName: "Default 1",
          greenName: "Default 2"
      );
      DataBaseHelper().insertBattleData(kDataBaseBattleListTableName, model);
      battleSpeedValue = [];// 清空数据

    }

  }

  /// 获取存储的solo数据
  void getStorageSoloData() async {
    final list = await DataBaseHelper().getData(kDataBaseTableName);
    if (list.length > 0) {
      recentlySoloModel = list.last;
      print("最近的一次数据为${recentlySoloModel}");
      /// 获取到最近的一次数据做动画
      measuredSoeedAnimation(int.parse(recentlySoloModel.speedData));
      setState(() {});
    }
 }

 /// 获取存储的battle数据
  void getStorageBattleData() async {
    final list = await DataBaseHelper().getBattleData(kDataBaseBattleListTableName);
    if (list.length > 0) {
      recentlyBattleModel = list.last;
      print('6666${recentlyBattleModel}');
    }
 }


  /// 根据测量到的速度做动画
  void measuredSoeedAnimation(int measureSpeed) {
   _timer?.cancel();
    currentSpeedValue = 0;
    progress = 0;
    setState(() {});
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (currentSpeedValue <  measureSpeed ) {
        currentSpeedValue += 1;
        progress += 0.005;
        // print('进度${progress}');
        setState(() {});
      }
    });
 }

  @override
  Widget build(BuildContext context) {
    NavigatorUtil.init(context);

    return MaterialApp(
      onGenerateRoute: Routes.onGenerateRoute,
      home: Scaffold(
        backgroundColor:Constants.darkControllerColor ,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 0,top: 58) ,
              child: GestureDetector( onTap: () async{

              },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(onTap: (){
                      print("蓝牙点击");
                      TTDialog.bleListDialog(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 0,left: 19),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Constants.bluetoothBGColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Image(image: AssetImage('images/home/bluetooth_icon.png'),width: 10,height: 20,),
                        ),
                      ),
                    ),

                    Constants.boldWhiteTextWidget("Myspeedz", 22),
                    Container(
                      margin: EdgeInsets.only(right: 24),
                      child: Image(
                        width:24,
                        height: 24,
                        image: AssetImage('images/home/setting_icon.png'),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Container(
              width: Constants.screenWidth(context),
              height: 400,
              margin: EdgeInsets.only(top: 30),
              child:  CircleProgressWidget(progress: Progress(value: progress,
                  calculateSpeed: currentSpeedValue,
                  redcalculateSpeed: redcalculateSpeed,
                  greencalculateSpeed: greencalculateSpeed,
                  color:Color.fromRGBO(46, 206, 255, 1),
                  backgroundColor: Constants.actionBGColor,
                  radius: 200, // 圆的半径
                  strokeWidth: 3,
                  dotCount: 72,
                  style: TextStyle(color: Colors.white,fontSize: 90),
                  completeText: "OK"

              ),mode: selectedMode,),
            ),

            GestureDetector(onTap: (){
              measuredSoeedAnimation(169);
            },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:indicatorColor,
                ),

              ),
            ),


            /// LIST
            Container(
              margin: EdgeInsets.only(top: 90,left: 40,right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(onTap: (){
                    NavigatorUtil.push(Routes.speedlist);
                  },
                    child: Container(
                      width: 85,
                      height: 57,
                      decoration: BoxDecoration(
                        color: selectedMode == CurrentMode.battleMode ?
                        Constants.switchBtnHighBGColor : Constants.actionBGColor ,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: selectedMode == CurrentMode.battleMode ?
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image(image: AssetImage('images/home/list_icon.png'),width: 20,height: 23,),
                        ),
                        SizedBox(width: 10,),
                        Constants.regularWhiteTextWidget("20", 16, Colors.white),
                      ],)
                          : Center(
                        child: Image(image: AssetImage('images/home/list_icon.png'),width: 20,height: 23,),
                      ),
                    ),
                  ),

                  SizedBox(width: 23,),

                  /// Battle
                  GestureDetector(onTap: (){
                     if (selectedMode == CurrentMode.battleMode) {
                       selectedMode = CurrentMode.soloMode;
                       indicatorColor = Constants.grayIndicatirColor;
                       /// 获取最近一条solo 数据 显示
                       currentSpeedValue = double.parse(recentlySoloModel.speedData);
                       /// 最近的最近一条solo做动画
                       measuredSoeedAnimation(int.parse(recentlySoloModel.speedData));

                     } else {
                       selectedMode = CurrentMode.battleMode;
                       indicatorColor = Constants.redIndicatirColor;
                       /// 获取最近一条battle 数据 显示
                       redcalculateSpeed = double.parse(recentlyBattleModel.redSpeedData);
                       greencalculateSpeed = double.parse(recentlyBattleModel.greenSpeedData);
                       /// 最近的蓝色数据做动画
                       measuredSoeedAnimation(int.parse(recentlyBattleModel.greenSpeedData));


                     }
                     setState(() {});
                   },
                    child: Container(
                      width: 85,
                      height: 57,
                      decoration: BoxDecoration(
                        color: selectedMode == CurrentMode.battleMode ?
                        Constants.battleHighBGColor : Constants.actionBGColor ,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: selectedMode == CurrentMode.battleMode ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image(image: AssetImage('images/home/battle_icon.png'),width: 26,height: 21,),
                          ),
                          SizedBox(width: 10,),
                          Constants.regularWhiteTextWidget("2", 16, Colors.white),
                        ],

                      ) :
                      Center(
                        child: Image(image: AssetImage('images/home/battle_icon.png'),width: 26,height: 21,),
                      ),


                      // Center(
                      //   child: Image(image: AssetImage('images/home/battle_icon.png'),width: 26,height: 21,),
                      // ),
                    ),
                  ),

                  SizedBox(width: 23,),


                  /// CHART
                  GestureDetector(onTap: (){
                    NavigatorUtil.push(Routes.speedChart);
                  },
                    child: Container(
                      // margin: EdgeInsets.only(top: 32,left: 32),
                      width: 85,
                      height: 57,
                      decoration: BoxDecoration(
                        color: Constants.actionBGColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: Center(
                        child: Image(image: AssetImage('images/home/chart_icon.png'),width: 26,height: 21,),
                      ),
                    ),
                  ),
                ],

              ),
            ),


            Container(
              margin: EdgeInsets.only(top: 8,left: 40,right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 85,
                    height: 57,
                    child:Constants.regularWhiteTextWidget("List", 16, Constants.typeTextColor),
                  ),
                  SizedBox(width: 23,),
                  Container(
                    width: 85,
                    height: 57,
                    child:Constants.regularWhiteTextWidget("Battle", 16, Constants.typeTextColor),
                  ),
                  SizedBox(width: 23,),

                  Container(
                    width: 85,
                    height: 57,
                    child:Constants.regularWhiteTextWidget("Chart", 16, Constants.typeTextColor),
                  ),


                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
}

