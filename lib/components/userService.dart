import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferencies {

  Future storeUserNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString('nickname', nickname);
  }

  Future<String?> get userNickname async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nickname');
  }
}
