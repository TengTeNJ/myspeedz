import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_speedz/full_screen_controller.dart';
import 'package:my_speedz/models/battle_speed_model.dart';
import 'package:my_speedz/models/solo_speed_model.dart';
import 'package:my_speedz/routes/routes.dart';
import 'package:my_speedz/utils/ble_util.dart';
import 'package:my_speedz/utils/blue_tooth_manager.dart';
import 'package:my_speedz/utils/data_base.dart';
import 'package:my_speedz/utils/dialog.dart';
import 'package:my_speedz/utils/event_bus.dart';
import 'package:my_speedz/utils/navigator_util.dart';
import 'package:my_speedz/utils/speedz_manager.dart';
import 'package:my_speedz/utils/string_util.dart';

import 'circle_progress_widget.dart';
import 'constants/constants.dart';

enum ShowBattleTopAvgMode {
  redData,// 红方数据
  greenDats // 蓝方数据
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

  String currentSpeedUnit = "Km/h"; /// 当前的速度单位

  int battleDataCount = 0; /// battle 的数据个数
  ///
  int soloDataCount = 0; /// solo 的数据个数

  Color indicatorColor = Constants.grayIndicatirColor; /// 指示灯的颜色
  Color progressColor = Constants.battleProgressRedColor; /// 进度条的颜色

  /// solo 的平均速度与最大速度
  List totalSoloData =[]; /// 总的solo 数据
  int soloAvgSpeed = 0;
  int soloTopSpeed = 0;

  /// battle 的平均速度与最大速度
  List totalBattleData =[]; /// 总的battle 数据
  int battleRedAvgSpeed = 0;
  int battleRedTopSpeed = 0;

  int battleGreenAvgSpeed = 0;
  int battleGreenTopSpeed = 0;
  // battle 数据默认显示red 的平均数据
  ShowBattleTopAvgMode showDataMode = ShowBattleTopAvgMode.redData;


  ///
  late StreamSubscription subscription;

  BattleSpeedModel recentlyBattleModel = BattleSpeedModel(redSpeedData: "0",
      greenSpeedData: "0",
      redName: "Default 1",
      greenName: "Default 2",
      time: "2025"    );
  SoloSpeedModel recentlySoloModel = SoloSpeedModel(speedData: "0", name: "Default 1",time: "14:01:02");

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

    BluetoothManager().disConnect = () {
      print("测速器断开连接了");
      battleDataCount = 0;
      soloDataCount = 0;
      setState(() {});
    };

    subscription = EventBus().stream.listen((event){
      if (event == kSpeedzNewSpeed) {
        getStorageSoloData();
        getStorageBattleData();
      }
    });

    listenDataChange();
    getStorageSoloData();
    getStorageBattleData();
  }

  void listenDataChange() {
    BluetoothManager().dataChange = (measureSpeed) {
      print("首页测量到的速度${measureSpeed}");
      /// 测量到数据红灯或者蓝灯闪一下在开始做动画
      if (selectedMode == CurrentMode.soloMode) {
        soloDataStorage(measureSpeed);
        progressColor =  Constants.battleProgressRedColor;
        indicatorColor = Constants.redIndicatirColor;
        recentlySoloModel = SoloSpeedModel(speedData: "${measureSpeed}", name: "Default 1", time: StringUtil.currentSoloTimeString());
        setState(() {});
        soloDataCount += 1;
        Future.delayed(Duration(milliseconds: 500),(){
          indicatorColor = Constants.grayIndicatirColor;
          setState(() {});
          measuredSoeedAnimation(measureSpeed);
        });
      } else {
        battleSpeedValue.add(measureSpeed);
        if (battleSpeedValue.length == 2) {
          progressColor =  Constants.battleProgressGreenColor;
          indicatorColor = Constants.greenIndicatirColor;
          greencalculateSpeed = measureSpeed.toDouble();
          battleDataStorage(); // 保存该轮比赛下双方的数据
          battleDataCount += 1;
        } else {
          progressColor =  Constants.battleProgressRedColor;
          indicatorColor = Constants.redIndicatirColor;
          redcalculateSpeed = measureSpeed.toDouble();
          greencalculateSpeed = 0;// 清空上一轮的蓝方的数据
        }
        setState(() {});
        Future.delayed(Duration(milliseconds: 500),(){
          indicatorColor = Constants.grayIndicatirColor;
          setState(() {});
          measuredSoeedAnimation(measureSpeed);
        });

      }
    };
  }

  // 计算solo 数据的平均 最快速度
  void calculateSoloAvgTopData() {
    var data = computeStats(totalSoloData);
    soloAvgSpeed = data['avg']!.toInt();
    soloTopSpeed = data['max']!.toInt();
    setState(() {});
  }

  void calculateBattleAvgTopData() {
    var redData = computeBattleStats(totalBattleData);
    var greenData = computeGreenBattleStats(totalBattleData);
    print("battle 模式下的${redData}");
    battleRedAvgSpeed = redData['avg']!.toInt();
    battleRedTopSpeed = redData['max']!.toInt();

    battleGreenAvgSpeed = greenData['avg']!.toInt();
    battleGreenTopSpeed = greenData['max']!.toInt();
    setState(() {});
  }

  /// solo数据存储
  void soloDataStorage(int speed) {
   var currentTime = StringUtil.currentSoloTimeString();
    var model = SoloSpeedModel(speedData: speed.toString(), name: "Default 1",time: currentTime);
    DataBaseHelper().insertData(kDataBaseTableName, model);
    totalSoloData.add(model);
    calculateSoloAvgTopData();
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

  /// 获取存储的solo数据
  void getStorageSoloData() async {
    final list = await DataBaseHelper().getData(kDataBaseTableName);
    totalSoloData = list;
    if (list.length > 0) {
      recentlySoloModel = list.last;
      print("最近的一次数据为${recentlySoloModel}");
      /// 获取到最近的一次数据做动画
      measuredSoeedAnimation(int.parse(recentlySoloModel.speedData));
      soloDataCount = list.length;
      /// 计算平均与最高
      calculateSoloAvgTopData();
      setState(() {});
    }
 }

  /// 获取存储的battle数据
  void getStorageBattleData() async {
    final list = await DataBaseHelper().getBattleData(kDataBaseBattleListTableName);
    totalBattleData = list;
    if (list.length > 0) {
      recentlyBattleModel = list.last;
      print('6666${recentlyBattleModel}');
      battleDataCount = list.length;
      //
      calculateBattleAvgTopData();
      redcalculateSpeed = double.parse(recentlyBattleModel.redSpeedData);
      greencalculateSpeed = double.parse(recentlyBattleModel.greenSpeedData);
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
        // print('进度${progress}');
        setState(() {});
      }
    });
 }

  /// 计算平均值与最大值
  Map<String, double> computeStats(List list) {
    if (list.isEmpty) return {'avg': 0.0, 'max': 0.0};

    double sum = 0.0;
    double max = double.parse(list.first.speedData);

    for (final e in list) {
      sum += (double.parse(e.speedData));
      if ((double.parse(e.speedData)) > max) max = (double.parse(e.speedData));
    }
    return {'avg': sum / list.length, 'max': max};
  }

  /// 计算battle(red)平均值与最大值
  Map<String, double> computeBattleStats(List list) {
    if (list.isEmpty) return {'avg': 0.0, 'max': 0.0};
    double sum = 0.0;
    double max = double.parse(list.first.redSpeedData);
    print("battle 最大值${max}");
    for (final e in list) {
      sum += (double.parse(e.redSpeedData));
      if ((double.parse(e.redSpeedData)) > max) max = (double.parse(e.redSpeedData));
    }
    return {'avg': sum / list.length, 'max': max};
  }

  Map<String, double> computeGreenBattleStats(List list) {
    if (list.isEmpty) return {'avg': 0.0, 'max': 0.0};
    double sum = 0.0;
    double max = double.parse(list.first.greenSpeedData);
    print("battle 最大值${max}");
    for (final e in list) {
      sum += (double.parse(e.greenSpeedData));
      if ((double.parse(e.greenSpeedData)) > max) max = (double.parse(e.greenSpeedData));
    }
    return {'avg': sum / list.length, 'max': max};
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

                    GestureDetector(onTap: (){
                      NavigatorUtil.push(Routes.fullScreen).then((value){
                          listenDataChange(); // 刷新数据监听
                          getStorageSoloData();
                          getStorageBattleData();
                      });
                      },
                     child: Container(
                       margin: EdgeInsets.only(right: 24),
                       child: Image(
                         width:24,
                         height: 24,
                         image: AssetImage('images/home/full_screen.png'),
                       ),
                     )
                    )

                  ],
                ),
              ),
            ),

            /// 圆环进度条
            Container(
              width: Constants.screenWidth(context),
              height: 400,
              margin: EdgeInsets.only(top: 30),
              child:  CircleProgressWidget(progress: Progress(value: progress,
                  calculateSpeed: currentSpeedValue,
                  redcalculateSpeed: redcalculateSpeed,
                  greencalculateSpeed: greencalculateSpeed,
                  // color:Color.fromRGBO(46, 206, 255, 1),
                  color:progressColor,
                  backgroundColor: Constants.actionBGColor,
                  radius: 200, // 圆的半径
                  strokeWidth: 3,
                  dotCount: 72,
                  style: TextStyle(color: Colors.white,fontSize: 90),
                  completeText: "OK"

              ),mode: selectedMode,),
            ),

            /// 指示器
            GestureDetector(onTap: (){
              // measuredSoeedAnimation(80);
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

            /// 平均速度 最快速度
            selectedMode == CurrentMode.battleMode ?
            Container(
              margin: EdgeInsets.only(top: 23,left: 40,right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(onTap: (){
                     if (showDataMode == ShowBattleTopAvgMode.redData) {
                       showDataMode = ShowBattleTopAvgMode.greenDats;
                     } else {
                       showDataMode = ShowBattleTopAvgMode.redData;
                     }
                     print("切换蓝红方top等数据");
                     setState(() {});
                  },
                   child: Container(
                     // color: Colors.red,
                     child:Column(

                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Constants.regularWhiteTextWidget("Top Speed", 16, Constants.typeTextColor),
                             SizedBox(width: 8,),
                             Image(
                               fit: BoxFit.cover,
                               width:12,
                               height: 7,
                               image: AssetImage('images/home/arrow_icon.png'),
                             ),
                           ],
                         ),
                         SizedBox(height: 4,),
                         showDataMode == ShowBattleTopAvgMode.redData ?
                         Constants.boldWhiteTextWidget("${BluetoothManager().currentSpeedUnit == "Km/h" ? battleRedTopSpeed.toStringAsFixed(0)
                             : (battleRedTopSpeed * 0.621371).toStringAsFixed(0)}${BluetoothManager().currentSpeedUnit}", 16)
                             :
                         Constants.boldWhiteTextWidget("${BluetoothManager().currentSpeedUnit == "Km/h" ? battleGreenTopSpeed.toStringAsFixed(0)
                             : (battleGreenTopSpeed * 0.621371).toStringAsFixed(0)}${BluetoothManager().currentSpeedUnit}", 16)
                       ],

                     ),
                   )
                  ),

                 GestureDetector(onTap: (){
                   if (showDataMode == ShowBattleTopAvgMode.redData) {
                     showDataMode = ShowBattleTopAvgMode.greenDats;
                   } else {
                     showDataMode = ShowBattleTopAvgMode.redData;
                   }
                   print("切换蓝红方top等数据");
                   setState(() {});
                 },
                   child:Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Constants.regularWhiteTextWidget("Avg.Speed", 16, Constants.typeTextColor),
                           SizedBox(width: 8,),
                           Image(
                             fit: BoxFit.cover,
                             width:12,
                             height: 7,
                             image: AssetImage('images/home/arrow_icon.png'),
                           ),
                         ],
                       ),
                       SizedBox(height: 4,),
                       showDataMode == ShowBattleTopAvgMode.redData ?
                       Constants.boldWhiteTextWidget("${battleRedAvgSpeed}km/h", 16)
                           :
                       Constants.boldWhiteTextWidget("${battleGreenAvgSpeed}km/h", 16)
                     ],

                   ),
                 ),


                ],
              ),
            )
            :
            Container(
              margin: EdgeInsets.only(top: 23,left: 40,right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Top Speed",
                      style: TextStyle(
                        color:Constants.typeTextColor,
                        fontFamily: 'SanFranciscoDisplay',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.2,),
                      children: <TextSpan>[
                        TextSpan(
                          text: '\n${soloTopSpeed}km/h',
                          style: TextStyle(
                            color:Colors.white,
                            fontFamily: 'SanFranciscoDisplay',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 1.2,
                          ),
                        ),


                      ])),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Avg.Speed",
                          style: TextStyle(
                            color:Constants.typeTextColor,
                            fontFamily: 'SanFranciscoDisplay',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 1.2,),
                          children: <TextSpan>[
                            TextSpan(
                              text: '\n${soloAvgSpeed} km/h',
                              style: TextStyle(
                                color:Colors.white,
                                fontFamily: 'SanFranciscoDisplay',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                height: 1.2,
                              ),
                            ),
                          ])),
                  // Constants.regularWhiteTextWidget("Avg.Speed", 16, Constants.typeTextColor)
                ],
              ),
            ),

            /// LIST
            Container(
              margin: EdgeInsets.only(top: 52,left: 40,right: 40),
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
                        color: Constants.switchBtnHighBGColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image(image: AssetImage('images/home/list_icon.png'),width: 20,height: 23,),
                        ),
                        SizedBox(width: 10,),
                        selectedMode == CurrentMode.battleMode ?
                        Constants.regularWhiteTextWidget("${battleDataCount}", 16, Colors.white)
                         :
                        Constants.regularWhiteTextWidget("${soloDataCount}", 16, Colors.white),

                      ],)
                         // :


                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Center(
                      //       child: Image(image: AssetImage('images/home/list_icon.png'),width: 20,height: 23,),
                      //     ),
                      //     SizedBox(width: 10,),
                      //     Constants.regularWhiteTextWidget("${battleDataCount}", 16, Colors.white),
                      //   ],)
                    ),
                  ),

                  SizedBox(width: 23,),

                  /// Battle
                  GestureDetector(onTap: (){
                     if (selectedMode == CurrentMode.battleMode) {
                       selectedMode = CurrentMode.soloMode;
                       BluetoothManager().mode = CurrentMode.soloMode;
                       indicatorColor = Constants.grayIndicatirColor;
                       progressColor =  Constants.battleProgressRedColor;
                       /// 获取最近一条solo 数据 显示
                       currentSpeedValue = double.parse(recentlySoloModel.speedData);
                       /// 最近的最近一条solo做动画
                       measuredSoeedAnimation(int.parse(recentlySoloModel.speedData));

                     } else {
                       selectedMode = CurrentMode.battleMode;
                       BluetoothManager().mode = CurrentMode.battleMode;
                       progressColor =  Constants.battleProgressRedColor;

                       // indicatorColor = Constants.redIndicatirColor;
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

