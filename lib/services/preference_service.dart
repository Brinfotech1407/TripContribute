import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService{
 static SharedPreferences? _preferences;


  static const String _userPhoneNo = 'USERPHONENO';
  static const String userLogin = 'USER_LOGIN';


 Future<void> init() async {
   _preferences = await SharedPreferences.getInstance();
 }

  Future<void> setUserPhoneNo(String userPhoneNo) async {
    await _preferences?.setString(_userPhoneNo, userPhoneNo);

  }

  bool? checkValue()  {
 return _preferences?.containsKey(_userPhoneNo);
}

  String? getUserPhoneNo(String key) {
    return _preferences?.getString(key);
  }

 Future<void> setUserType(bool userTypeValue) async {
   await _preferences?.setBool(userLogin, userTypeValue);
 }
 bool getUserType() {
   return _preferences?.getBool(userLogin) ?? false;
 }
}