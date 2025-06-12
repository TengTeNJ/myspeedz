class SpeedModel{
  String type = ''; // solo 或者battle

  String userName = ''; //
  String speedValue = ''; //

  bool selected = false; // 选中状态，用于标记数据选中
  int speed = 10; // 速度
  String indexString = '1';


  SpeedModel(this.userName,this.speedValue);
}
