import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'settings.dart';
import '../model/PrefViewModel.dart';
import '../modules/preferences.dart';
import '../modules/timer_event.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ランテンポ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', ''),
      ],
      home:TopPage(),
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => new TopPage(),
        '/settings': (BuildContext context) => new SettingsPage()
      },
    );
  }
}


class TopPage extends StatelessWidget{

  final pref_data = PrefViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PrefViewModel>.value(
      value: pref_data,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('　　ランテンポ')),
          elevation: 0,
          iconTheme: new IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'settings',
              onPressed: (){
                Navigator.of(context).pushNamed('/settings');
              },
            ),
          ],
        ),
        body: MainPage(),
      )
    );
  }
}

class MainPage extends StatelessWidget{
  TimerEvent timerevent = TimerEvent();

  @override
  Widget build(BuildContext context) {
    final PrefViewModel pref_data = context.watch<PrefViewModel>();

    // 設定情報の読み込み
    getPrefs(pref_data);

    return  Container(
      padding: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            BPMRow(timerevent),
            SliderRow(timerevent),
            StartButtonRow(timerevent),
            DetailContainer(timerevent),
          ],
        ),
      ),
    );
  }
}

class BPMRow extends StatelessWidget{
  TimerEvent timerevent;

  // コンストラクタ
  BPMRow(this.timerevent);

  @override
  Widget build(BuildContext context) {
    final PrefViewModel pref_data = context.watch<PrefViewModel>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(""),
            ),
            Expanded(
              flex: 3,
              child: Container(
                  margin: const EdgeInsets.all(10.0),
                  width: 150.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                    controller: TextEditingController()..text = pref_data.bpm.toString(),
                    enabled: timerevent.is_started ? false : true,
                    onSubmitted: (text){
                      int value;
                      int old_value = pref_data.bpm;
                      try{
                        value = int.parse(text);
                        if(BPM_MIN <= value && value <= BPM_MAX) {
                          pref_data.set_bpm(value);
                          setInt_pref('bpm', value);
                        } else {
                          pref_data.set_bpm(old_value);
                        }
                      } catch(e, s) {
                        pref_data.bpm = old_value;
                      }
                    },
                  )
              ),
            ),
            Expanded(
              flex: 2,
              child: Text('bpm'),
            )
          ],
        ),
    );
  }
}

class SliderRow extends StatelessWidget{
  TimerEvent timerevent;

  // コンストラクタ
  SliderRow(this.timerevent);

  @override
  Widget build(BuildContext context) {
    final PrefViewModel pref_data = context.watch<PrefViewModel>();

    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
        children: [
          Ink(
            decoration: const ShapeDecoration(
              color: Colors.black12,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.remove),
              tooltip: 'Decrease bpm by 5',

              onPressed: () {
                int value = pref_data.bpm - 5;
                if(value < BPM_MIN){
                  value = BPM_MIN.toInt();
                }
                pref_data.set_bpm(value);
                setInt_pref('bpm', value);
                timerevent.setTimer(pref_data, true);
              },
            ),
          ),
          Flexible(
            child: Slider(
              value: pref_data.bpm.toDouble(),
              min: BPM_MIN.toDouble(),
              max: BPM_MAX.toDouble(),
              onChanged: (double value){
                print(value);
                pref_data.set_bpm(value.toInt());
                setInt_pref('bpm', value.toInt());
                timerevent.setTimer(pref_data, true);
              },
            ),
          ),
          Ink(
            decoration: const ShapeDecoration(
              color: Colors.greenAccent,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Increase bpm by 5',
              onPressed: () {
                int value = pref_data.bpm + 5;
                if(value > BPM_MAX){
                  value = BPM_MAX.toInt();
                }
                pref_data.set_bpm(value);
                setInt_pref('bpm', value);
                timerevent.setTimer(pref_data, true);
              },
            ),
          ),
        ],
      )
    );
  }
}

class StartButtonRow extends StatelessWidget{
  TimerEvent timerevent;

  // コンストラクタ
  StartButtonRow(this.timerevent);

  @override
  Widget build(BuildContext context) {
    final PrefViewModel pref_data = context.watch<PrefViewModel>();

    return Container(
      padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
      width: 250.0,
      child: SizedBox(
        height: 200,
        width: 200,
        child: ElevatedButton(
            onPressed: (){
              timerevent.is_started = !timerevent.is_started;
              timerevent.setTimer(pref_data, false);
            },

            style: ButtonStyle(
              backgroundColor:timerevent.is_started ?
              (pref_data.flush_state ?
              MaterialStateProperty.all<Color>(Colors.yellowAccent) :
              MaterialStateProperty.all<Color>(Colors.black12))
                  : MaterialStateProperty.all<Color>(Colors.blue),
            ),
            child: Text(timerevent.is_started ? 'ストップ': 'スタート',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 45,
                    color: timerevent.is_started ?
                    (pref_data.flush_state ? Colors.redAccent : Colors.white)
                        : Colors.white)
            )
        ),
      ),
    );
  }
}

class DetailContainer extends StatelessWidget{
  TimerEvent timerevent;

  // コンストラクタ
  DetailContainer(this.timerevent);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [

          Consumer<PrefViewModel>(
            builder: (context, pref, child){
              return Text('設定内容確認');
            },
          ),
          Consumer<PrefViewModel>(
            builder: (context, pref, child){
              return Text('is_ring:${pref.is_ring.toString()}');
            },
          ),
          Consumer<PrefViewModel>(
            builder: (context, pref, child){
              return Text('is_light:${pref.is_light.toString()}');
            },
          ),
          Consumer<PrefViewModel>(
            builder: (context, pref, child){
              return Text('is_vibe:${pref.is_vibe.toString()}');
            },
          ),
          Consumer<PrefViewModel>(
            builder: (context, pref, child){
              return Text('bpm:${pref.bpm.toString()}');
            },
          ),
          Consumer<PrefViewModel>(
            builder: (context, pref, child){
              return Text('更新間隔:${timerevent.duration.toString()}ミリ秒');
            },
          ),
          Consumer<PrefViewModel>(
            builder: (context, pref, child){
              return Text('timeritem:${pref.timeritem}');
            },
          ),
        ],
      ),
    );
  }
}