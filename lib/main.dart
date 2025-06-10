import 'package:flutter/material.dart';
import 'package:my_speedz/circle_progress_widget.dart';
import 'package:my_speedz/constants/constants.dart';
import 'package:square_progress_indicator/square_progress_indicator.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
   double progress = 0;
  // late Progress progress;
  // bool isInitialized = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // progress.value = 0.5;
    // isInitialized = true;
    setState(() {});
  }

  Widget _infoLeftText(String s) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text("🤩 $s", style: const TextStyle(color: Color(0xff445b79))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

                    Text('Myspeedz',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'tengxun',
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
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
              // color: Color.fromRGBO(233, 29, 32, 1.0),
              margin: EdgeInsets.only(top: 30),
              child:  CircleProgressWidget(progress: Progress(value: progress,
                  color:Color.fromRGBO(46, 206, 255, 1),
                backgroundColor: Colors.grey,
                radius: 200, // 圆的半径
                strokeWidth: 4,
                dotCount: 60,
                style: TextStyle(color: Colors.white,fontSize: 90),
                completeText: "OK"

              )),
            ),

            GestureDetector(onTap: (){
                progress += 0.01;
                setState(() {});
                },
             child: Container(
               width: 20,
               height: 20,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 color: Constants.grayIndicatirColor,
               ),

             ),
            ),


            Container(
              margin: EdgeInsets.only(top: 90,left: 40,right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(onTap: (){
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
                        child: Image(image: AssetImage('images/home/list_icon.png'),width: 20,height: 23,),
                      ),
                    ),
                  ),

                  SizedBox(width: 23,),

                  GestureDetector(onTap: (){

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
                        child: Image(image: AssetImage('images/home/battle_icon.png'),width: 26,height: 21,),
                      ),
                    ),
                  ),

                  SizedBox(width: 23,),

                  GestureDetector(onTap: (){

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