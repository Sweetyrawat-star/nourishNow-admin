import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static late SharedPreferences sharedPreferences;

  static init() async{
    sharedPreferences= await SharedPreferences.getInstance();
  }
  static dynamic getData({required key}){
    return sharedPreferences.get(key);
  }

  static Future<dynamic> putData({required String key, required dynamic data})async
  {
    if(data is List<String>)
      {
        return await(sharedPreferences.setStringList(key, data));
      }
    if (data is bool)
    {
      return await(sharedPreferences.setBool(key, data));
    }
    if (data is String) {
      return await(sharedPreferences.setString(key, data));
    }
    if(data is int) {
      return await(sharedPreferences.setInt(key, data));
    } else {
      return  await(sharedPreferences.setDouble(key, data));
    }
  }
}