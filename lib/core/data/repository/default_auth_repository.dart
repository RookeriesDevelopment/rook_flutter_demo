import 'package:rook_flutter_demo/core/domain/future/delay.dart';
import 'package:rook_flutter_demo/core/domain/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultAuthRepository implements AuthRepository {
  final SharedPreferencesAsync _sharedPreferences = SharedPreferencesAsync();

  @override
  Future<String?> getUserID() async {
    await delay(seconds: 1); // Simulate Network delay

    return _sharedPreferences.getString(userIDKey);
  }

  @override
  Future<void> login(String userID) async {
    await delay(seconds: 1); // Simulate Network delay

    return _sharedPreferences.setString(userIDKey, userID);
  }

  @override
  Future<void> logout() async {
    await delay(seconds: 1); // Simulate Network delay

    return _sharedPreferences.remove(userIDKey);
  }
}

const String userIDKey = "user_id";
