class BattleSpeedModel {
  String id = '0';
  String redSpeedData = '0'; // 红方速度
  String greenSpeedData = '0'; // 蓝方速度

  String redName = ''; // 红方名字
  String greenName = ''; // 蓝方名字
  String time = ''; // 时间（图表用）


  String index = ''; // 索引（图表用）


  BattleSpeedModel({required this.redSpeedData,
                   required this.greenSpeedData,
                   required this.redName,
                   required this.greenName,
                   required this.time });


  factory BattleSpeedModel.modelFromJson(Map<String, dynamic> json) {
    BattleSpeedModel model =  BattleSpeedModel(
      redSpeedData: json['redSpeedData'] ?? '0',
      greenSpeedData: json['greenSpeedData'] ?? '0',
      redName: json['redName'] ?? '0',
      greenName: json['greenName'] ?? '0',
      time: json['time'] ?? '0',
    );
    return model;
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'redSpeedData': this.redSpeedData,
        'greenSpeedData': this.greenSpeedData,
        'redName': this.redName,
        'greenName': this.greenName,
        'id': this.id,
        'time': this.time,
      };

}