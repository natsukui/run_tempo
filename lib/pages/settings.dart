import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../model/PrefViewModel.dart';
import '../modules/preferences.dart';

class SettingsPage extends StatelessWidget{

  final pref_data = PrefViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PrefViewModel>.value(
      value: pref_data,
      child:  Scaffold(
        appBar: AppBar(
          title: new Text('設定'),
        ),
        body: _SettingsPage(),
      )
    );
  }
}

class _SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final PrefViewModel pref_data = context.watch<PrefViewModel>();

    // 設定情報の読み込み
    getPrefs(pref_data);

    return Container(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
              child: SwitchListTile(
                value: pref_data.is_ring,
                onChanged: (bool? value) {
                  setBool_pref('is_ring', value!);
                  pref_data.set_ring(value);
                },
                title: Text('音'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
              child: SwitchListTile(
                value: pref_data.is_light,
                onChanged: (bool? value) {
                  setBool_pref('is_light', value!);
                  pref_data.set_light(value);
                },
                title: Text('ライト'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
              child: SwitchListTile(
                value: pref_data.is_vibe,
                onChanged: (bool? value) {
                  setBool_pref('is_vibe', value!);
                  pref_data.set_vibe(value);
                },
                title: Text('バイブレーション'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
              child: ElevatedButton(
                  onPressed: () async{
                    print('test button');
                    //int streamId = await _pool.play(gsoundId!);
                  },
                  child: Text('test!')
              ),
            ),
          ],
        )
    );
  }
}