import 'dart:math';

import 'package:flutter/material.dart';

class CircleProgressWidget extends StatefulWidget {
  final Progress progress;

  CircleProgressWidget({required this.progress});
  @override
  _CircleProgressWidgetState createState() => _CircleProgressWidgetState();
}


class _CircleProgressWidgetState extends State<CircleProgressWidget> {
  @override
  Widget build(BuildContext context) {
    var progress = Container(
      width: widget.progress.radius * 2,
      height: widget.progress.radius * 2,
      child: CustomPaint(
        painter: ProgressPainter(progress: widget.progress,
            paint123: Paint(),
            arrowPath: Path(),
            arrowPaint: Paint(),
            radius: widget.progress.radius - widget.progress.strokeWidth / 2),
      ),
    );
    String txt = "${(100 * widget.progress.value).toStringAsFixed(0)}";
    // var text = Text(
    //   widget.progress.value == 1.0 ? widget.progress.completeText : txt,
    //   style: widget.progress.style ??
    //       TextStyle(fontSize: widget.progress.radius / 6),
    // );
    //
    // var unit = Text(
    //   "Km/h",
    //    style:TextStyle(fontSize: 30,color: Colors.white) ,
    // );

    var rich = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: txt,
            style: TextStyle(
              color:Colors.white,
              fontFamily: 'tengxun',
              fontWeight: FontWeight.w400,
              fontSize: 90,
              height: 1.2,


            ),
            children: <TextSpan>[
              TextSpan(
                text: '\nKm/h',
                style: TextStyle(
                  fontFamily: 'SanFranciscoDisplay',
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  height: 1.0,

                ),
              ),
            ]));

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[progress,rich],
    );
  }
}

class ProgressPainter extends CustomPainter {
  Progress progress;
  Paint paint123;
  Paint arrowPaint;
  Path arrowPath;
  double radius;

  ProgressPainter({
    required this.progress,
    required this.paint123,
    required this.arrowPath,
    required this.arrowPaint,
    required this.radius
  });


  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    canvas.clipRect(rect); //裁剪区域
    canvas.translate(progress.strokeWidth / 2, progress.strokeWidth / 2);

    drawProgress(canvas);
    drawArrow(canvas);
    drawDot(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  drawProgress(Canvas canvas) {
    canvas.save();
    paint123//背景
      ..style = PaintingStyle.stroke
      ..color = progress.backgroundColor
      ..strokeWidth = progress.strokeWidth;

    paint123//进度
      ..color = Color.fromRGBO(1, 0, 0, 1.0)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    double sweepAngle = progress.value * 360; //完成角度
    print(sweepAngle);

    // 创建圆的画笔
    Offset center = Offset( 196, 196);
    canvas.drawCircle(center, 135, paint123);


    // 创建圆的边框画笔
    Paint strokePaint = Paint()
      ..color = Color.fromRGBO(71, 71, 71, 1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, 135, strokePaint);
    canvas.restore();
  }

  drawArrow(Canvas canvas) {
    canvas.save();
    canvas.translate((progress.radius - progress.strokeWidth), (progress.radius - progress.strokeWidth));// 将画板移到中心
    canvas.rotate((180 + progress.value * 360) / 180 * pi);//旋转相应角度
    var half = (progress.radius - progress.strokeWidth) / 2;//基点
    var eg = (progress.radius - progress.strokeWidth) / 50; //单位长
    arrowPath.moveTo(0, -half - eg * 2);
    arrowPath.relativeLineTo(eg * 2, eg * 6);
    arrowPath.lineTo(0, -half + eg * 2);
    arrowPath.lineTo(0, -half - eg * 2);
    arrowPath.relativeLineTo(-eg * 2, eg * 6);
    arrowPath.lineTo(0, -half + eg * 2);
    arrowPath.lineTo(0, -half - eg * 2);
    canvas.drawPath(arrowPath, arrowPaint);
    canvas.restore();
  }

  void drawDot(Canvas canvas) {
    canvas.save();
    int num = progress.dotCount;
    canvas.translate((progress.radius - progress.strokeWidth), (progress.radius - progress.strokeWidth));
    for (double i = 0; i < num; i++) {
      canvas.save();
      double deg = 360 / num * i + 180;
      canvas.rotate(deg / 180 * pi);
      paint123
        ..strokeWidth = progress.strokeWidth / 2
        ..color = progress.backgroundColor
        ..strokeCap = StrokeCap.round;
      if (i * (360 / num) <= progress.value * 360) {
        paint123..color = progress.color;
      }
      print("起始点${(progress.radius - progress.strokeWidth) * 3 / 4}");
      print("终点${(progress.radius - progress.strokeWidth) * 4 / 5}");

      Point point1 = Point(0, (progress.radius - progress.strokeWidth) * 3 / 4);
      Point point2 = Point(0, (progress.radius - progress.strokeWidth) * 4 / 8);

      double distance = calculateDistance(point1, point2);
      print('两个点之间的距离是: $distance');

      canvas.drawLine(
          Offset(0, (progress.radius - progress.strokeWidth) * 3 / 4),
          Offset(0, (progress.radius - progress.strokeWidth) * 4 / 5),
          paint123);
      canvas.restore();
    }
    canvas.restore();
  }

  double calculateDistance(Point point1, Point point2) {
    double x1 = point1.x;
    double y1 = point1.y;
    double x2 = point2.x;
    double y2 = point2.y;

    double distance = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    return distance;
  }
}

class Point {
  double x;
  double y;

  Point(this.x, this.y);
}

///信息描述类 [value]为进度，在0~1之间,进度条颜色[color]，
///未完成的颜色[backgroundColor],圆的半径[radius],线宽[strokeWidth]
///小点的个数[dotCount] 样式[style] 完成后的显示文字[completeText]
class Progress {
  double value = 0.5;
  Color color = Colors.green;
  Color backgroundColor = Colors.red;
  double radius = 1.0;
  double strokeWidth = 3.0;
  int dotCount = 40;
  TextStyle style = TextStyle(color: Colors.white);
  String completeText = "OK";

  Progress({required this.value,
            required this.color,
    required this.backgroundColor,
    required this.radius,
    required this.strokeWidth,

    required this.dotCount,
    required this.style,
    required this.completeText,


  }) {
    // 初始化逻辑
  }

}
