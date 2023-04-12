import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService{
 static SharedPreferences? _preferences;


  static const String User_PhoneNo = 'USERPHONENO';
  static const String User_Name = 'USERNAME';
  static const String userLogin = 'USER_LOGIN';


 Future<void> init() async {
   _preferences = await SharedPreferences.getInstance();
 }

 Future<bool>? setString(String key, String? value) {
   return _preferences?.setString(key, value ?? '');
 }

 String? getString(String key) {
   return _preferences?.getString(key);
 }


 Future<bool>? setBool(String key, bool? value) {
   return _preferences?.setBool(key, value ?? false);
 }

 bool? getBool(String key) {
   return _preferences?.getBool(key);
 }

}