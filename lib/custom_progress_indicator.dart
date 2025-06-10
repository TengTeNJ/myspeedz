import 'package:flutter/cupertino.dart';
import 'package:square_progress_indicator/square_progress_indicator.dart';
import 'main.dart';


class CustomProgressIndicator extends StatefulWidget {
  double value;
  int  totalSteps;
  final Color segmentColor;
  final Color backgroundColor;

  // const CustomProgressIndicator({super.key});

    CustomProgressIndicator({
    required this.value,
    required this.totalSteps,
    required this.segmentColor,
    required this.backgroundColor,
  });

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return SquareProgressIndicator(
      value: widget.value,
      width: 200, // 进度条宽度
      height: 20, // 进度条高度
      borderRadius: 10, // 边角半径
      strokeCap: StrokeCap.round, // 线段端点样式
      color:  widget.segmentColor, // 进度颜色
      emptyStrokeColor:  widget.backgroundColor, // 背景颜色
      strokeWidth: 10, // 进度条线宽
      emptyStrokeWidth: 10, // 背景线宽
      strokeAlign: SquareStrokeAlign.center, // 进度条对齐方式
    );
  }
}



// import 'dart:ui';
// import 'package:square_progress_indicator/square_progress_indicator.dart';
// class CustomProgressIndicator extends StatelessWidget {
//   final double value;
//   final int totalSteps;
//   final Color segmentColor;
//   final Color backgroundColor;
//
//   CustomProgressIndicator({
//     required this.value,
//     required this.totalSteps,
//     required this.segmentColor,
//     required this.backgroundColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SquareProgressIndicator(
//       value: value,
//       width: 200, // 进度条宽度
//       height: 20, // 进度条高度
//       borderRadius: 0, // 边角半径
//       strokeCap: StrokeCap.square, // 线段端点样式
//       color: segmentColor, // 进度颜色
//       emptyStrokeColor: backgroundColor, // 背景颜色
//       strokeWidth: 4, // 进度条线宽
//       emptyStrokeWidth: 4, // 背景线宽
//       strokeAlign: SquareStrokeAlign.center, // 进度条对齐方式
//     );
//   }