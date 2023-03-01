import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService{
 static SharedPreferences? _preferences;


  static const String _userPhoneNo = 'USERPHONENO';


 Future<void> init() async {
   _preferences = await SharedPreferences.getInstance();
 }

  Future<void> setUserPhoneNo(String userPhoneNo) async {
   print('bhavika service screen $userPhoneNo');
    await _preferences?.setString(_userPhoneNo, userPhoneNo);

  }

  bool? checkValue()  {
 return _preferences?.containsKey(_userPhoneNo);
}

  String? getUserPhoneNo(String key) {
    print('bhavika get service screen $_userPhoneNo');
    return _preferences?.getString(key);
  }
}