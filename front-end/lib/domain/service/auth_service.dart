import 'package:exercise_calendar/domain/service/storage_service.dart';
import 'package:exercise_calendar/domain/user/user_repository.dart';

class AuthService {
  final StorageService _storageService = StorageService();
  final UserRepository _userRepository = UserRepository();

  // 로그인 로직
  Future<bool> login(String username, String password) async {
    try {
      String? token = await _userRepository.login(username, password);
      if (token != null) {
        await _storageService.saveToken(token); // 토큰 저장
        return true;
      }
      return false;
    } catch (e) {
      print("로그인 실패: $e");
      return false;
    }
  }

  // 로그아웃 로직
  Future<void> logout() async {
    await _storageService.deleteToken(); // 토큰 삭제
  }

  // 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    return await _storageService.hasToken();
  }
}
