import 'package:flutter/material.dart';
import '../constants/constants.dart';

class BattleDataView extends StatefulWidget {
  const BattleDataView({super.key});

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
              margin: EdgeInsets.only(left: 10,right: 10),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('80',
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


                  Text('70',
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
            Container(
              // margin: EdgeInsets.only(t),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Constants.mediumWhiteTextWidget("Km/h", 30, Colors.white),
                  SizedBox(width: 6,),

                  Container(
                    // color:  Constants.darkControllerColor,
                    // width: 20,
                    // height: 20,
                    child: Image(
                      fit: BoxFit.contain,
                      width:12,
                      height: 7,
                      image: AssetImage('images/home/arrow_icon.png'),
                    ),
                  ),
                ],
              ),
            ),




            SizedBox(height: 10,),

          ]
      ),
    );
  }
}
