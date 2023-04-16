import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtService {
  get token async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'jwt');
  }

  get userId async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'userId');
  }

  Future storeUserId(String userId) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'userId', value: userId);
  }

  Future store(String token) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'jwt', value: token);
  }

  Future deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'jwt');
  }
}
