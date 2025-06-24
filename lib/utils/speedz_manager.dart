
class SpeedzManager {
  /*RobotManager设置为单例模型*/
  static SpeedzManager _instance = SpeedzManager._sharedInstance();

  factory SpeedzManager() {
    return _instance;
  }

  SpeedzManager._sharedInstance();

  Function(int measuredSpeed)? dataChange;

  // _triggerCallback({int  measuredSpeed = 0 }) {
  //   dataChange?call(measuredSpeed);
  // }

  // 数据改变时内部调用
  _triggerCallback({int measuredSpeed = 0, required int}) {
    dataChange?.call(measuredSpeed);
  }

  handleData(int data) {
   SpeedzManager()._triggerCallback(int:data);
  }

}