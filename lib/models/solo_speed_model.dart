class SoloSpeedModel {
  String id = '0';
  String speedData = '0'; // 捡球数量
  String name = ''; // 捡球日期
  String index = ''; // 索引（图表用）


  SoloSpeedModel({required this.speedData,required this.name});


  factory SoloSpeedModel.modelFromJson(Map<String, dynamic> json) {
    SoloSpeedModel model =  SoloSpeedModel(
      speedData: json['speedData'] ?? '0',
      name: json['name'] ?? '0',
    );
    return model;
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'speedData': this.speedData,
        'name': this.name,
        'id': this.id,
      };

}