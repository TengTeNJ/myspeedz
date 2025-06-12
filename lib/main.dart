import 'package:flutter/material.dart';
import 'package:my_speedz/circle_progress_widget.dart';
import 'package:my_speedz/constants/constants.dart';
import 'package:my_speedz/routes/routes.dart';
import 'package:my_speedz/solo_home_controller.dart';
import 'package:my_speedz/utils/navigator_util.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    NavigatorUtil.init(context);
    return MaterialApp(
      onGenerateRoute: Routes.onGenerateRoute,
      home: SoloHomeController()
    );
  }
}