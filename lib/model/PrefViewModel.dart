import 'package:flutter/material.dart';

class PrefViewModel extends ChangeNotifier{
  // 音を鳴らすかどうか
  bool is_ring = false;
  void set_ring(bool value){
    is_ring = value;
    notifyListeners();
    print('set_ring ' + value.toString());
  }

  // フラッシュライトを光らせるかどうか
  bool is_light = false;
  void set_light(bool value){
    is_light = value;
    notifyListeners();
  }

  // バイブレーションさせるかどうか
  bool is_vibe = false;
  void set_vibe(bool value){
    is_vibe = value;
    notifyListeners();
  }

  // テンポ
  int bpm = 100;
  void set_bpm(int value){
    bpm = value;
    notifyListeners();
  }

  bool flush_state = false;
  void set_flush_state(bool value){
    flush_state = value;
    notifyListeners();
  }

  // なにか確認用に文字列を入れます
  String timeritem = '';
  void set_timeritem(String value){
    timeritem = value;
    notifyListeners();
  }
}