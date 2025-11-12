abstract interface class AuthRepository {
  Future<String?> getUserID();
  Future<void> login(String userID);
  Future<void> logout();
}
