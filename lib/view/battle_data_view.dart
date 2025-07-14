import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../utils/blue_tooth_manager.dart';
import '../utils/data_base.dart';

class BattleDataView extends StatefulWidget {
  double speedData;
  double greenSpeedData;

  BattleDataView({required this.speedData, required this.greenSpeedData});

  @override
  State<BattleDataView> createState() => _BattleDataViewState();
}

class _BattleDataViewState extends State<BattleDataView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: 240,
      height: 240,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Constants.screenWidth(context),
              margin: EdgeInsets.only(left: 24,top: 36,right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Column(
                    children: [
                      Container(
                        // color:  Constants.darkControllerColor,
                        child: Image(
                          fit: BoxFit.fitWidth,
                          width:14.24,
                          height: 17.26,
                          image: AssetImage('images/home/red_icon.png'),
                        ),
                      ),
                      Constants.regularWhiteTextWidget("Default 1", 16, Constants.typeTextColor),
                    ],
                  ),

                  Column(
                    children: [
                      Container(
                        // color:  Constants.darkControllerColor,
                        child: Image(
                          fit: BoxFit.contain,
                          width:14.24,
                          height: 17.26,
                          image: AssetImage('images/home/green_icon.png'),
                        ),
                      ),
                      Constants.regularWhiteTextWidget("Default 2", 16, Constants.typeTextColor),

                    ],
                  ),
                ],
              ),
            ),



            /// 80   |   70
            Container(
              // color: Colors.red,
              margin: EdgeInsets.only(left: 10,right: 10),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text('${BluetoothManager().currentSpeedUnit == "Km/h" ? widget.speedData.toStringAsFixed(0)
                      : (widget.speedData * 0.621371).toStringAsFixed(0)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'tengxun',
                      color: Colors.white,
                      fontSize: 70,
                    ),
                  ),

                  SizedBox(width: 10,),
                  Container(
                    width: 0.5,
                    height: 30,
                    color: Colors.white,
                  ),

                  SizedBox(width: 10,),


                  Text('${BluetoothManager().currentSpeedUnit == "Km/h" ? widget.greenSpeedData.toStringAsFixed(0)
                      : (widget.greenSpeedData * 0.621371).toStringAsFixed(0)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'tengxun',
                      color: Colors.white,
                      fontSize: 70,
                    ),
                  ),

                ],
              ),
            ),

            /// km/h 箭头
            GestureDetector(onTap: (){
              if (BluetoothManager().currentSpeedUnit == "Km/h") {
                BluetoothManager().currentSpeedUnit = "Mp/h";
                DataBaseHelper().saveSpeedUnitData("Mp/h");
                print("切换速度单位${BluetoothManager().currentSpeedUnit}");
              } else {
                BluetoothManager().currentSpeedUnit = "Km/h";
                DataBaseHelper().saveSpeedUnitData("Km/h");
                print("切换速度单位${BluetoothManager().currentSpeedUnit}");
              }
              setState(() {});

            },
              child:Container(
                // margin: EdgeInsets.only(t),
                // color: Colors.red,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Constants.mediumWhiteTextWidget("${BluetoothManager().currentSpeedUnit}", 30, Colors.white),
                     Container(
                        // color: Colors.red,
                          child: Padding(padding: EdgeInsets.all(10),
                            child: Image(
                              fit: BoxFit.cover,
                              width:12,
                              height: 7,
                              image: AssetImage('images/home/arrow_icon.png'),
                            ),

                          )
                      ),
                  ],
                ),
              ),

            ),





            SizedBox(height: 10,),

          ]
      ),
    );
  }
}
