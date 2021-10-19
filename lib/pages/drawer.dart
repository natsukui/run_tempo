import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../model/PrefViewModel.dart';
import '../modules/preferences.dart';

class DrawerPage extends StatelessWidget{
  Widget build(BuildContext context) {
    final PrefViewModel pref_data = context.watch<PrefViewModel>();

    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('設定', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
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