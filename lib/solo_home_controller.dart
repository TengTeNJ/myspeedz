import 'dart:async';

import 'package:flutter/material.dart';
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
  double currentSpeedValue = 0;
  CurrentMode selectedMode = CurrentMode.soloMode;
  Timer? _timer;


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
      dataStorage(measureSpeed);
    };

    getStorageData();
  }

  /// 数据存储
  void dataStorage(int speed) {
    var model = SoloSpeedModel(speedData: speed.toString(), name: "Default 1");
    DataBaseHelper().insertData(kDataBaseTableName, model);
  }

  /// 获取存储的数据
  void getStorageData() async {
    final list = await DataBaseHelper().getData(kDataBaseTableName);
    if (list.length > 0) {
      var recentlyModel = list.last;
      print("最近的一次数据为${recentlyModel}");
      /// 获取到最近的一次数据做动画
      measuredSoeedAnimation(int.parse(recentlyModel.speedData));
      setState(() {});
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
        print('进度${progress}');
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
              measuredSoeedAnimation(26);
            },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                  selectedMode == CurrentMode.battleMode ?
                  Constants.greenIndicatirColor : Constants.grayIndicatirColor ,
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
                     } else {
                       selectedMode = CurrentMode.battleMode;
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

