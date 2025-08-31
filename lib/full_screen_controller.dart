import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_speedz/constants/constants.dart';
import 'package:my_speedz/utils/blue_tooth_manager.dart';
import 'package:my_speedz/utils/data_base.dart';
import 'package:my_speedz/utils/event_bus.dart';
import 'package:my_speedz/utils/navigator_util.dart';
import 'package:my_speedz/utils/string_util.dart';

import 'models/battle_speed_model.dart';
import 'models/solo_speed_model.dart';

class FullScreenController extends StatefulWidget {
  String recentlySoloSpeed = "0";
  FullScreenController({
    this.recentlySoloSpeed = "",
  });

  @override
  State<FullScreenController> createState() => _FullScreenControllerState();
}

class _FullScreenControllerState extends State<FullScreenController> {
  int recentlySoloSPeed= 0 ;
  int currentSpeedValue = 0;


  int recentlyBattleRedSpeed= 0 ;
  int recentlyBattleGreenSpeed= 0 ;

  Color indicatorColor = Constants.grayIndicatirColor; /// 指示灯的颜色

  Timer? _timer;

  List battleSpeedValue = [];// battle 数据 （只存两个数据）

  void speedAnimation(int measureSpeed) {
    _timer?.cancel();
    currentSpeedValue = 0;
    setState(() {});
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (currentSpeedValue <  measureSpeed ) {
        currentSpeedValue += 1;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  void BattlespeedAnimation(int measureSpeed,int type) {
    _timer?.cancel();
    if (type == 1) { //红方
      recentlyBattleRedSpeed = 0;
    } else {
      recentlyBattleGreenSpeed = 0;
    }
    setState(() {});
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (type == 1) {
        if (recentlyBattleRedSpeed <  measureSpeed ) {
          recentlyBattleRedSpeed += 1;
          if (mounted) {
            setState(() {});
          }
        }
      } else {
        if (recentlyBattleGreenSpeed <  measureSpeed ) {
          recentlyBattleGreenSpeed += 1;
          if (mounted) {
            setState(() {});
          }
        }
      }


    });
  }





  /// 获取存储的solo数据
  void getStorageSoloData() async {
    final list = await DataBaseHelper().getData(kDataBaseTableName);
    if (list.length > 0) {
      var model = list.last;
      recentlySoloSPeed = int.parse(model.speedData);
      speedAnimation(recentlySoloSPeed);
      setState(() {});
    }
  }

  /// 获取存储的battle数据
  void getStorageBattleData() async {
    final list = await DataBaseHelper().getBattleData(kDataBaseBattleListTableName);
    if (list.length > 0) {
      var battleModel = list.last;
      recentlyBattleRedSpeed = int.parse(battleModel.redSpeedData);
      recentlyBattleGreenSpeed = int.parse(battleModel.greenSpeedData);
      setState(() {});
    }
  }

  /// solo数据存储
  void soloDataStorage(int speed) {
    var currentTime = StringUtil.currentSoloTimeString();
    var model = SoloSpeedModel(speedData: speed.toString(), name: "Default 1",time: currentTime);
    DataBaseHelper().insertData(kDataBaseTableName, model);
  }

  /// battle数据存储
  void battleDataStorage() {
    var todayTime = StringUtil.currentTimeString();
    if (battleSpeedValue.length == 2) {
      var model = BattleSpeedModel(redSpeedData: battleSpeedValue[0].toString(),
          greenSpeedData: battleSpeedValue[1].toString(),
          redName: "Default 1",
          greenName: "Default 2",
          time:todayTime
      );
      DataBaseHelper().insertBattleData(kDataBaseBattleListTableName, model);
      battleSpeedValue = [];// 清空数据
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStorageSoloData();
    getStorageBattleData();
    listenDataChange();
  }

  void listenDataChange() {
    BluetoothManager().dataChange = (measureSpeed) {
      print("全屏界面测量到的速度为${measureSpeed}");
      EventBus().sendEvent(kSpeedzNewSpeed);
      if (BluetoothManager().mode == CurrentMode.soloMode) {
        recentlySoloSPeed = measureSpeed;
        speedAnimation(measureSpeed);
        soloDataStorage(measureSpeed);
        indicatorColor = Constants.redIndicatirColor;
        setState(() {});
        Future.delayed(Duration(milliseconds: 500),(){
          indicatorColor = Constants.grayIndicatirColor;
          setState(() {});
        });
      }else if (BluetoothManager().mode == CurrentMode.battleMode) {
        battleSpeedValue.add(measureSpeed);

        if (battleSpeedValue.length == 2) {
          print("全屏界面蓝方测量到的速度为${measureSpeed}");
          indicatorColor = Constants.greenIndicatirColor;
          setState(() {});
          BattlespeedAnimation(measureSpeed,2);
          battleDataStorage();// 保存该轮比赛下双方的数据
          Future.delayed(Duration(milliseconds: 500),(){
            indicatorColor = Constants.grayIndicatirColor;
            setState(() {});
          });
        } else {
          print("全屏界面红方测量到的速度为${measureSpeed}");
          indicatorColor = Constants.redIndicatirColor;
          setState(() {});
          BattlespeedAnimation(measureSpeed,1);
          Future.delayed(Duration(milliseconds: 500),(){
            indicatorColor = Constants.grayIndicatirColor;
            setState(() {});
          });

        }
      }
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  void dispose() {
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 29, 32, 1.0),
      body: Stack(
        children: [
          Positioned(
              top: 57,
              right: 24,
             child: GestureDetector(onTap: (){
               NavigatorUtil.pop();
             },
               child: Image(image: AssetImage('images/home/half_screen.png'),
                 width: 24,height: 24,),
             ),
          ),

          BluetoothManager().mode == CurrentMode.soloMode ?
          Center(
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Constants.tengxunBoldWhiteTextWidget("${BluetoothManager().currentSpeedUnit == "Km/h" ? currentSpeedValue.toStringAsFixed(0)
                  : (currentSpeedValue * 0.621371).toStringAsFixed(0)}", 150),
                  SizedBox(height: 9,),
                  Constants.mediumWhiteTextWidget("${BluetoothManager().currentSpeedUnit}", 30, Colors.white),
                ],
              )
          )
          :
          Center(
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Constants.tengxunBoldWhiteTextWidget("${BluetoothManager().currentSpeedUnit == "Km/h" ? recentlyBattleRedSpeed.toStringAsFixed(0)
                 : (recentlyBattleRedSpeed * 0.621371).toStringAsFixed(0)}", 150),
                  SizedBox(height: 9,),
                  Constants.mediumWhiteTextWidget("${BluetoothManager().currentSpeedUnit}", 30, Colors.white),

                  SizedBox(height: 37,),
                  Container(
                    width: Constants.screenWidth(context) - 34 * 2,
                    height: 1,
                    color: Color.fromRGBO(112, 112, 112, 1),
                  ),
                  SizedBox(height: 37,),

                  Constants.tengxunBoldWhiteTextWidget("${BluetoothManager().currentSpeedUnit == "Km/h" ? recentlyBattleGreenSpeed.toStringAsFixed(0)
                      : (recentlyBattleGreenSpeed * 0.621371).toStringAsFixed(0)}", 150),
                  SizedBox(height: 9,),
                  Constants.mediumWhiteTextWidget("${BluetoothManager().currentSpeedUnit}", 30, Colors.white),
                ],
              )
          ),

          /// 原点指示器
          Positioned(
              left: Constants.screenWidth(context)/2 - 18,
              bottom: 78,
              child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: indicatorColor
            ),
          )
          ),
        ],
      ),
    );
  }

}
