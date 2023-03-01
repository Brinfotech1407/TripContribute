import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService{
  SharedPreferences? _preferences;

  static const String _username = 'USERNAME';
  static const String _userPhoneNo = 'USERPHONENO';


  @override
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setUserPhoneNo(String userPhoneNo) async {
    await _preferences?.setString(_userPhoneNo, userPhoneNo);
  }

  String? getUserPhoneNo() {
    return _preferences?.getString(_userPhoneNo);
  }
}