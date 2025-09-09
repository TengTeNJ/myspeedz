import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:my_speedz/utils/data_base.dart';
import 'package:my_speedz/utils/speedz_manager.dart';

import '../constants/constants.dart';
import '../models/ble_model.dart';
import 'event_bus.dart';


class BluetoothManager{
  static final BluetoothManager _instance = BluetoothManager._internal();

  factory BluetoothManager() {
    _instance.listenBLEStatu();

    return _instance;
  }

  BluetoothManager._internal();

  final _ble = FlutterReactiveBle();

  // 蓝牙列表
  List<BLEModel> deviceList = [];

  List<BLEModel> get showDeviceList {
    List<BLEModel> virtualList = [];

    this.deviceList.forEach((element){
       virtualList.add(element);


    });
    print("扫描到的蓝牙设备${virtualList}");
    return virtualList;
  }

  // 已连接的蓝牙设备列表
  List<BLEModel>  get hasConnectedDeviceList  {
    return  this.deviceList.where((element) => element.hasConected == true).toList();
  }


  final ValueNotifier<int> deviceListLength = ValueNotifier(-1);

  // 已连接的设备数量
  final ValueNotifier<int> conectedDeviceCount = ValueNotifier(0);

  Stream<DiscoveredDevice>? _scanStream;

  StreamSubscription? _bleStatuListen;
  StreamSubscription? _bleListen;

  int currentSpeed = 0;

  /// 当前的速度单位
  String currentSpeedUnit = "Km/h";
  CurrentMode mode = CurrentMode.soloMode; /// 当前的测量模式


  Function(int measuredSpeed)? dataChange; // 测量到速度变化
  Function()? disConnect; // 机器人断链

  /*开始扫描*/
  Future<void> startNewScan() async {
    // 不能重复扫描
    if (_scanStream != null) {
      print('返回了');
      return;
    }
    _scanStream = _ble.scanForDevices(
      withServices: [],
      scanMode: ScanMode.lowLatency,
    );
    _bleListen = _scanStream!.listen((DiscoveredDevice event) {
      // 处理扫描到的蓝牙设备
      if (event.name.isEmpty) {
        return;
      }
      // print('蓝牙名字${event.name}');

      //  && event.name == kBLEDevice_NewName
      if (!hasDevice(event.id) && event.name == kBLEDevice_NewName) {
        print('蓝牙名字${event.name}');
        this.deviceList.add(BLEModel(device: event));
        deviceListLength.value = this.deviceList.length;
        var model = this.deviceList.last;
        if (conectedDeviceCount.value == 0 && model.device.name == kBLEDevice_NewName) {
          // 已经连接的设备少于两个 则自动连接
          // conectToDevice(this.deviceList.last);
          // BluetoothManager().blueNameChange?.call(model.device.name);
        }
      }
    });
  }


  /*连接设备*/
  conectToDevice(BLEModel model) {
    if (model.hasConected == true || conectedDeviceCount.value > 0) {
      // 已连接状态直接返回
      print("已经连接设备了");
      return;
    }
    EasyLoading.show(status: "connecting...",maskType:EasyLoadingMaskType.clear);

    StreamSubscription<ConnectionStateUpdate> stream =  _ble
        .connectToDevice(
        id: model.device.id, connectionTimeout: Duration(seconds: 10))
        .listen((ConnectionStateUpdate connectionStateUpdate) {
      print('connectionStateUpdate = ${connectionStateUpdate.connectionState}');
      if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.connected) {
        // 连接成功主动发送心跳回复响应(获取准确电量)
        // BLESendUtil.heartBeatResponse();
        if(Platform.isAndroid){
          // 请求高优先级连接
          _ble.requestConnectionPriority(deviceId: model.device!.id, priority: ConnectionPriority.highPerformance);
        }
        // 连接设备数量+1
        conectedDeviceCount.value++;
        // 已连接
        model.hasConected = true;
        // 保存读写特征值
        late final notifyCharacteristic;
        if(model.device.name == kBLEDevice_NewName){
          // seeker bot
          notifyCharacteristic = QualifiedCharacteristic(
              serviceId: Uuid.parse(kBLE_270_SERVICE_UUID),
              characteristicId: Uuid.parse(kBLE_270_CHARACTERISTIC_NOTIFY_UUID),
              deviceId: model.device.id);
          model.notifyCharacteristic = notifyCharacteristic;
        }


        // 连接成功弹窗
        EasyLoading.showSuccess('Bluetooth connection successful');
        EasyLoading.dismiss();
        EventBus().sendEvent(kConnectSuccess);

        // 监听数据
        // Future.delayed(Duration(milliseconds: 2000),(){
          _ble.subscribeToCharacteristic(notifyCharacteristic).listen((data) {
            print("deviceId =${model.device.id}---上报来的数据data = $data");
              List<int> bytes = data;
              BluetoothManager().dataChange?.call(bytes[0]);
          });
        // });
      } else if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.disconnected) {
          EasyLoading.showError('disconected',duration: Duration(milliseconds: 5000));
          /// 断链删除数据
          DataBaseHelper().deleteData(kDataBaseTableName, "0");
          DataBaseHelper().deleteData(kDataBaseBattleListTableName, "0");

          BluetoothManager().disConnect?.call();
        if(conectedDeviceCount.value > 0){
          conectedDeviceCount.value--;
        }
        // 失去连接
        model.hasConected = false;
        this.deviceList.remove(model);
        deviceListLength.value = this.deviceList.length;
      }
    });
    model.bleStream = stream;
  }

  /*断开连接 */
  disconnectDevice(BLEModel model) {
    model.bleStream?.cancel();
    EasyLoading.showToast('Disconnected');
    if (conectedDeviceCount.value > 0) {
      conectedDeviceCount.value--;
      if (conectedDeviceCount.value == 0) {
        // 所有设备断开
        _instance._bleListen?.cancel();
        _instance._bleListen = null;
        _instance._scanStream = null;
      }
    }
    model.hasConected = false;
    EventBus().sendEvent(kInitiativeDisconnectFive);
  }

  /*判断是否已经被添加设备列表*/
  bool hasDevice(String id) {
    Iterable<BLEModel> filteredDevice =
    this.deviceList.where((element) => element.device.id == id);
    return filteredDevice != null && filteredDevice.length > 0;
  }

  listenBLEStatu() {
    if (_bleStatuListen == null) {
      _bleStatuListen = FlutterReactiveBle().statusStream.listen((status) {
        print('蓝牙状态status===${status}');
        // GameUtil gameUtil = GetIt.instance<GameUtil>();
        // gameUtil.bleStatus = status;
        if (status == BleStatus.poweredOff) {
          // 蓝牙开关关闭
          _instance._bleListen?.cancel();
          _instance._bleListen = null;
          _instance._scanStream = null;
          // _instance.disConnect?.call();
          print('蓝牙关闭');
        } else if (status == BleStatus.locationServicesDisabled) {
          // 安卓位置权限不允许
        } else if (status == BleStatus.unauthorized) {
          // 未授权蓝牙权限
        } else if (status == BleStatus.ready) {
          // _instance.openBlueTooth?.call();
          print('蓝牙打开');
          Future.delayed(Duration(milliseconds: 100),(){
            startNewScan();
          });

        }
      });
    }
  }

}

