import 'package:flutter/material.dart';
import 'package:my_speedz/models/speed_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../constants/constants.dart';
import '../utils/color.dart';
import 'my_stats_tip_view.dart';


class MyStatsBarChatView extends StatefulWidget {
  List<SpeedModel> datas = [];
  double maxLeft;
  int maxCount = 3;

  MyStatsBarChatView({required this.datas, this.maxLeft = 0 ,this.maxCount = 0});
  @override
  State<MyStatsBarChatView> createState() => _MyStatsBarChatViewState();
}

class _MyStatsBarChatViewState extends State<MyStatsBarChatView> {
  late TooltipBehavior _tooltipBehavior;
  bool _disposed = false;
  double _width = 0.3; // 柱状图宽度


  void _callback(Duration duration) {
    if (!_disposed) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateWidthBaseDatas();
    _tooltipBehavior = TooltipBehavior(
      // shouldAlwaysShow: true,
      canShowMarker: false,
      enable: true,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        SpeedModel model = data as SpeedModel;
        return MyStatsTipView(dataModel: model);
      },
    );
  }

/*根据数据量计算宽度*/
  calculateWidthBaseDatas() {
    if (widget.datas.length == 1) {
      _width = 0.05;
    } else if (widget.datas.length > 1 && widget.datas.length <= 6) {
      _width = 0.15;
    } else if (widget.datas.length > 6 && widget.datas.length <= 9) {
      _width = 0.2;
    } else if (widget.datas.length > 9 && widget.datas.length <= 13) {
      _width = 0.3;
    } else if (widget.datas.length > 13 && widget.datas.length <= 17) {
      _width = 0.5;
    } else {
      _width = 0.6;
    }
  }

  /*选中柱形图*/
  selectItem(SpeedModel model) {
    widget.datas.forEach((SpeedModel number) {
      number.selected = false;
    });
    model.selected = true;
    // 使用 SchedulerBinding.instance.addPostFrameCallback 来延迟调用 setState，以确保在构建完成后再更新状态
    WidgetsBinding.instance.addPersistentFrameCallback(_callback);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding:
            EdgeInsets.only(left: 10, top: 22 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Constants.mediumBaseTextWidget('Highest ${widget.maxCount}', 16),
              ],
            ),

            // child: Constants.mediumBaseTextWidget('Highest ${widget.maxCount}', 16),
        ),
        Container(
          // color: Colors.red,
          height: 480,
          margin: EdgeInsets.only(right: 16,top: 24),
          child: SfCartesianChart(
              margin: EdgeInsets.only(left: 10, right: 0, top: 10),
              plotAreaBorderWidth: 0,
              // 设置绘图区域的边框宽度为0，隐藏边框
              plotAreaBorderColor: Colors.transparent,
              // 设置绘图区域的边框颜色为透明色
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(
                  color: Color.fromRGBO(156, 156, 156, 1.0),
                  fontSize: 12,
                  fontFamily: 'SanFranciscoDisplay',
                  fontWeight: FontWeight.w500,
                ),
                maximum: 200,
                labelAlignment: LabelAlignment.center,
                interval: 20,
                // X 轴的宽度与颜色  这里设置为透明色，以虚线显示
                axisLine: AxisLine(width: 1, color: Colors.transparent),
                // 设置 X 轴轴线颜色和宽度
                plotOffset: 0,
                labelPosition: ChartDataLabelPosition.outside,
                // labelStyle: TextStyle(fontSize: 12, color: Colors.black), // 设置标签样式
                majorGridLines: MajorGridLines(
                    color: Color.fromRGBO(112, 112, 112, 1.0),
                    dashArray: [2, 2]),
               majorTickLines: MajorTickLines(width: 0),

              ),
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(
                  color: Colors.transparent,
                  fontSize: 8,
                  fontFamily: 'SanFranciscoDisplay',
                  fontWeight: FontWeight.w400,
                ),
                plotOffset: 1,
                interval: 1,
                axisLine: AxisLine(width: 1, color: Colors.transparent),
                // 设置 X 轴轴线颜色和宽度
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                // 调整标签位置，使得第一个数据和 Y 轴有间隔
                majorGridLines: MajorGridLines(
                    color: Colors.transparent, dashArray: [5, 5]),
                majorTickLines: MajorTickLines(width: 0),
                // minimum: 0, // 设置Y轴的最小值
                // maximum: 10, // 设置Y轴的最大值
              ),
              tooltipBehavior: _tooltipBehavior,
              series: <CartesianSeries<SpeedModel, num>>[
                // Renders column chart
                ColumnSeries<SpeedModel, num>(
                    selectionBehavior: SelectionBehavior(
                      enable: true, // 这个设置为true,会在选中时，其他的置灰

                      // toggleSelection: false,
                      // overlayMode: ChartSelectionOverlayMode.top, // 设置选中视图显示在柱状图上面
                    ),
                    borderRadius: BorderRadius.circular(5),
                    // 设置柱状图的圆角
                    dataSource: widget.datas,
                    width: _width,
                    // 设置柱状图的宽度，值为 0.0 到 1.0 之间，表示相对于间距的比例
                    spacing: 0.5,
                    //
                    xValueMapper: (SpeedModel data, _) =>
                        int.parse(data.indexString),
                    yValueMapper: (SpeedModel data, _) =>
                        data.speed > 50 ? data.speed : data.speed,
                    pointColorMapper: (SpeedModel data, _) =>
                        hexStringToColor('#F8850B'))
              ]),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposed = true;
    super.dispose();
  }
}
