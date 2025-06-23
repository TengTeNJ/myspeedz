import 'package:flutter/material.dart';
import 'package:my_speedz/utils/blue_tooth_manager.dart';

import '../constants/constants.dart';

class BleListView extends StatefulWidget {
  const BleListView({super.key});

  @override
  State<BleListView> createState() => _BleListViewState();
}

class _BleListViewState extends State<BleListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // /color: Colors.orange,
      margin: EdgeInsets.only(left: 16, right: 16),
      width: Constants.screenWidth(context) - 32,
      height: Constants.screenHeight(context) * 0.45 - 99 - 44,
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return index != BluetoothManager().showDeviceList.length
                ? InkWell(
              child: Container(
                height: 60,
                width: Constants.screenWidth(context),
                child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // BluetoothManager()
                        //     .showDeviceList[index]
                        //     .hasConected ==
                        //     true
                        //     ? Image(
                        //   image: AssetImage(
                        //       'images/participants/point.png'),
                        //   width: 14,
                        //   height: 14,
                        // )
                        //     : Container(),
                        SizedBox(
                          width: 8,
                        ),
                        Constants.mediumWhiteTextWidget(
                          BluetoothManager()
                              .showDeviceList[index]
                              .device.name,
                          16,Colors.white
                        )
                      ],
                    )),
              ),
              onTap: () {
                print('连接蓝牙设备');
                // if (BluetoothManager()
                //     .showDeviceList[index]
                //     .hasConected ==
                //     true ||
                //     BluetoothManager().showDeviceList[index].modelStatu ==
                //         BLEModelStatu.virtual) {
                //   // 虚拟设备和已连接设备不需要连接
                //   print('虚拟设备和已连接设备不需要连接');
                //   if (BluetoothManager()
                //       .showDeviceList[index]
                //       .hasConected ==
                //       true) {
                //     print('已连接设备断开连接');
                //     BluetoothManager().disconecteDevice(
                //         BluetoothManager().showDeviceList[index]);
                //     //BluetoothManager().showDeviceList[index].bleStream?.cancel();
                //   }
                // } else {
                //   // 每次只能有一个设备连接 如果有已连接的 则先断开
                //   if (BluetoothManager().hasConnectedDeviceList.length ==
                //       1) {
                //     BLEModel model =
                //     BluetoothManager().hasConnectedDeviceList[0];
                //     BluetoothManager().disconecteDevice(model);
                //   }
                  BluetoothManager().conectToDevice(
                      BluetoothManager().showDeviceList[index]);
                // }
              },
            )
                : SizedBox();
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            thickness: 2,
            color: Color.fromRGBO(86, 86, 116, 1.0),
          ),
          itemCount: BluetoothManager().showDeviceList.length + 1),
    );

  }
}
