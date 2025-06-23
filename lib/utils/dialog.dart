import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_speedz/view/ble_list_view.dart';

import '../constants/constants.dart';
import 'color.dart';
import 'navigator_util.dart';

class TTDialog {
  /**蓝牙列表**/
  static bleListDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: BLEListDialog(),
        );
      },
    );
  }



}

/**蓝牙列表弹窗**/
class BLEListDialog extends StatefulWidget {
  const BLEListDialog({super.key});

  @override
  State<BLEListDialog> createState() => _BLEListDialogState();
}

class _BLEListDialogState extends State<BLEListDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Constants.darkControllerColor),
      child: Stack(
        children: [
          Positioned(
              top: 8,
              left: (Constants.screenWidth(context) - 80) / 2.0,
              child: Container(
                  width: 80,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color.fromRGBO(89, 105, 138, 0.4),
                  ))),
          Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  print('断开连接 break');

                },
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: hexStringToColor('#65657D'),
                          borderRadius: BorderRadius.circular(18)),
                      child: Center(
                        child: Image(
                            image: AssetImage('images/ble/disconnect.png'),
                            width: 16),
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  print('begain scan');
                  // BleUtil.begainScan(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: hexStringToColor('#65657D'),
                          borderRadius: BorderRadius.circular(18)),
                      child: Center(
                        child: Image(
                            image: AssetImage('images/ble/scan.png'),
                            width: 16),
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
            child: BleListView(),
            top: 45,
            bottom: 99,
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                NavigatorUtil.pop();
              },
              child: Container(
                child: Center(
                  child: Constants.regularWhiteTextWidget("Cancle", 16, Colors.white),

                ),
                decoration: BoxDecoration(
                    color: Constants.baseStyleColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            left: 83,
            right: 83,
            bottom: 42,
            height: 40,
          )
        ],
      ),
    );
  }
}