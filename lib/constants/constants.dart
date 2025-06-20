import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color.dart';

class Constants {

  // 生成随机数
  static int randomNumberLeftMargin(int number) {
    return Random().nextInt(number);
  }

  static int randomNumberTopMargin(int number) {
    return Random().nextInt(number);
  }
  //  屏幕宽度
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  //  屏幕高度
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Text regularWhiteTextWidget(String text, double fontSize,Color color,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0}) {
    return Text(
      maxLines: maxLines ?? null,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: color,
          fontSize: fontSize),
    );
  }

  static Text mediumWhiteTextWidget(String text, double fontSize,Color color,
      {int maxLines = 1,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0}) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.clip,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: color,
          fontSize: fontSize),
    );
  }

  static Text boldWhiteTextWidget(String text, double fontSize,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
        height: height,
        fontFamily: 'SanFranciscoDisplay',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: fontSize,
      ),
    );
  }

  static Text boldBaseTextWidget(String text, double fontSize,
      {int maxLines = 1,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay4',
          fontWeight: FontWeight.bold,
          color: Constants.baseStyleColor,
          fontSize: fontSize),
    );
  }

  static Text regularGreyTextWidget(String text, double fontSize,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0,
        TextOverflow? overflow}) {
    return Text(
      maxLines: maxLines ?? null,
      textAlign: textAlign,
      textScaler: TextScaler.noScaling,
      text,
      style: TextStyle(
          overflow: overflow,
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Constants.baseGreyStyleColor,
          fontSize: fontSize),
    );
  }

  static Text actionRegularGreyTextWidget(String text, double fontSize,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0,
        TextOverflow? overflow}) {
    return Text(
      maxLines: maxLines ?? null,
      textAlign: textAlign,
      text,
      style: TextStyle(
          overflow: overflow,
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: fontSize),
    );
  }

  static Text mediumBaseTextWidget(String text, double fontSize,
      {int maxLines = 1,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0}) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(241, 18, 18, 1.0),
          fontSize: fontSize),
    );
  }

  static Text customTextWidget(String text, double fontSize, String color,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0,
        FontWeight? fontWeight,
        TextOverflow? overflow}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines ?? null,
      text,
      style: TextStyle(
          overflow: overflow,
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: fontWeight,
          color:hexStringToColor(color),

        fontSize: fontSize),
    );
  }

  static Color darkThemeColor = Color.fromRGBO(38, 38, 48, 1);
  static Color darkThemeOpacityColor = Color.fromRGBO(41, 41, 54, 0.24);
  static Color baseStyleColor = Color.fromRGBO(248, 133, 11, 1);
  static Color baseGreyStyleColor = Color.fromRGBO(177, 177, 177, 1);
  static Color darkControllerColor = Color.fromRGBO(28, 29, 32, 1);
  static Color baseControllerColor = Color.fromRGBO(41, 41, 54, 1);
  static Color grayTextColor = Color.fromRGBO(156, 156, 156, 1);
  static Color connectTextColor = Color.fromRGBO(204, 204, 204, 1);
  static Color selectModelBgColor = Color.fromRGBO(56, 58, 64, 1);
  static Color selectedModelBgColor = Color.fromRGBO(233, 100, 21, 1);
  static Color baseTextGrayBgColor = Color.fromRGBO(67, 67, 65, 1);
  static Color selectedModelTransparencyBgColor = Color.fromRGBO(233, 100, 21, 0.39);
  static Color selectedModelOrangeBgColor = Color.fromRGBO(233, 100, 21, 1.0);
  static Color dialogBgColor = Color.fromRGBO(49, 52, 67, 1);
  static Color powerOffDialogBgColor = Color.fromRGBO(61, 19, 18, 1);
  static Color remindIndicatorColor = Color.fromRGBO(248, 98, 21, 1);


  static Color bluetoothBGColor = Color.fromRGBO(32, 71, 209, 1);
  static Color grayIndicatirColor = Color.fromRGBO(93, 93, 93, 1);
  static Color actionBGColor = Color.fromRGBO(53, 54, 59, 1);
  static Color typeTextColor = Color.fromRGBO(180, 180, 180, 1);
  static Color switchBtnHighBGColor = Color.fromRGBO(44, 88, 220, 1);
  static Color controllerBGColor = Color.fromRGBO(39, 41, 48, 1);
  static Color battleHighBGColor = Color.fromRGBO(85, 67, 200, 1);





  static Color cameraPickBgColor = Color.fromRGBO(19 , 19, 20, 1);
  static Color cameraPickChooseAreaBgColor = Color.fromRGBO(27 , 66, 197, 0.75);
  static Color cameraPickChoosedAreaBgColor = Color.fromRGBO(25 , 243, 134, 1.0);


  static Color customSliderUnselectedColor = Color.fromRGBO(220, 220, 220, 1);
  static Color customSliderSelectedColor = Color.fromRGBO(233, 100, 21, 1);


  static Color newPickBgColor = Color.fromRGBO(86, 45, 28, 1);

  static String connectRobotText =
      'Connect your phone to your bots Bluetooth.The Bluetooth name is';

  static String kTcpIPAdress = '10.10.100.254';
  static int kTcpPort = 12345;
}
const kDataBaseTableName = 'ball_table'; // 数据库的表名(捡球数量)
const kDataBasePickupBallTimeTableName = 'ball_time_table'; //数据库的表名(捡球时间)

const kDataFrameHeader = 0xA5; // 数据帧头
const kDataFrameFoot = 0xAA; // 数据帧尾
// 全局监听
const kTCPDataListen = 'tcp_data_listen'; //  TCP数据监听

// 蓝牙设置名字
const kBLEDevice_NewName = 'seekbot2.0';
// 新版本的digital shoots和270的蓝牙模块保持一致
const kBLE_270_SERVICE_UUID = "181A";
const kBLE_270_CHARACTERISTIC_NOTIFY_UUID = "2A6E";
const kBLE_270_CHARACTERISTIC_WRITER_UUID = "2A6F";

/// 数据回调
/// 跳转到捡球界面
const KJumpPickPage =
    'robot_jump_pick_page';
//机器人捡球时间更新
const kRobotPickballTimeChange =
    'robot_pickball_time_change';
//机器人捡球数量更新
const kRobotPickballCountChange =
    'robot_pickball_count_change';
//机器人断链通知到连接界面
const kRobotConnectChange =
    'robot_connect_change';

