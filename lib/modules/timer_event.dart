import '../model/PrefViewModel.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_flashlight/flutter_flashlight.dart';
import 'dart:async';

import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';

class TimerEvent{
  final Soundpool _pool = Soundpool(streamType: StreamType.notification);

  Timer? _timer;
  int soundId = 0;
  bool _is_started = false;
  bool get is_started => _is_started;
  set is_started(bool value) => _is_started = value;

  int _duration = 0;
  int get duration => _duration;

  Future<int> getSoundID() async {
    ByteData soundData = await rootBundle.load("assets/audios/button45.mp3");
    int soundId = await _pool.load(soundData);
    return soundId;
  }
  TimerEvent(){
    _init();
  }
  Future<void> _init() async {
    this.soundId = await getSoundID();
  }

  void _fire(PrefViewModel pref_data) async {

    pref_data.set_flush_state(!pref_data.flush_state);

    DateTime today = DateTime.now();
    pref_data.set_timeritem(today.toString());

    // 振動させる
    if(pref_data.is_vibe){
      if(pref_data.flush_state) {
        if ((await Vibration.hasCustomVibrationsSupport())!) {
          Vibration.vibrate(duration: 100);
        } else {
          Vibration.vibrate();
          await Future.delayed(Duration(milliseconds: 100));
          Vibration.vibrate();
        }
      }
    }

    // フラッシュライトを点滅
    if(pref_data.is_light){
      if(pref_data.flush_state) {
        Flashlight.lightOn();
        Flashlight.lightOff();
      }
    }

    // 音を鳴らす
    if(pref_data.is_ring){
      if(pref_data.flush_state) {
        int streamId = await _pool.play(this.soundId);
      }
    }

  }


  void setTimer(PrefViewModel pref_data, bool is_change) async {
    // タイマーの間隔。何msecごとに実行するか。
    // 120bpmで60s/120bpm=0.5sだとon->off->onまでの1周期が1sかかってしまうので更に半分にする
    this._duration = (60 / pref_data.bpm * 1000 / 2).toInt();

    if(this.is_started == true){
      if(is_change){
        // タイマー起動中に呼ばれたので間隔変更
        print('reset');
        // 一旦停止して、間隔を変更する
        this._timer!.cancel();
        this._timer = Timer.periodic(
            Duration(milliseconds: this._duration),
                (Timer timer) {
              _fire(pref_data);
            }
        );
      } else {
        print('start');
        // スタートボタンをタップした
        this._timer = Timer.periodic(
            Duration(milliseconds: this._duration),
                (Timer timer) {
              _fire(pref_data);
            }
        );
      }
    } else {
      // 停止する
      Flashlight.lightOff();
      this._timer!.cancel();
    }
  }
}