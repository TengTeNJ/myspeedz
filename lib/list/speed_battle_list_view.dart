import 'package:flutter/material.dart';
import 'package:my_speedz/list/speed_battle_item_view.dart';
import 'package:my_speedz/models/battle_speed_model.dart';

class SpeedBattleListView extends StatefulWidget {
  List<BattleSpeedModel> datas;
  SpeedBattleListView({required this.datas});

  @override
  State<SpeedBattleListView> createState() => _SpeedListViewState();
}

class _SpeedListViewState extends State<SpeedBattleListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context ,index){
          return SpeedBattleItemView(model: widget.datas[index]);
        }, separatorBuilder: (context ,index) => SizedBox(
      height: 16,
    ), itemCount: widget.datas.length);
  }
}

