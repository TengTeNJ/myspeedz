import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_speedz/chart/speed_chart_controller.dart';
import 'package:my_speedz/list/speed_list_controller.dart';


class Routes {
  static const String speedlist = 'speedList'; // 速度列表页面
  static const String speedChart = 'speedChart'; // 图表界面

  static RouteFactory onGenerateRoute = (settings) {
    switch (settings.name) {
      case speedlist:
        return MaterialPageRoute(builder: (_) => SpeedListController());
      case speedChart:
        return MaterialPageRoute(builder: (_)=> SpeedChartController());

    }
  };
}