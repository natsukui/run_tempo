import 'package:shared_preferences/shared_preferences.dart';
import '../model/PrefViewModel.dart';

final int BPM_MIN = 50;
final int BPM_MAX = 300;

void getPrefs(PrefViewModel pref_data) async {
  // sharepreferencesの値を取得します

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // PrefViewModelへ値をセットします
  pref_data.set_ring(prefs.getBool('is_ring') ?? false);
  pref_data.set_light(prefs.getBool('is_light') ?? false);
  pref_data.set_vibe(prefs.getBool('is_vibe') ?? false);
  pref_data.set_bpm(prefs.getInt('bpm') ?? 100);
}


void setInt_pref(String key, int value) async {
  // sharepreferencesへ値をセットします
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key, value);
}

void setBool_pref(String key, bool value) async {
  // sharepreferencesへ値をセットします
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}
