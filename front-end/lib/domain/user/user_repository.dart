import 'package:exercise_calendar/controller/dto/LoginReqDto.dart';
import 'package:exercise_calendar/controller/dto/SignupReqDto.dart';
import 'package:exercise_calendar/domain/user/user_provider.dart';
import 'package:get/get_connect/http/src/response/response.dart';

//통신을 호출해서 응답되는 데이터를 예쁘게 가공 (json => dart오브젝트 )
class UserRepository {
  final UserProvider _userProvider = UserProvider();

  Future<String> login(String username, String password) async {
    //dart 오브젝트
    LoginReqDto loginReqDto = LoginReqDto(username, password);
    print(loginReqDto.toJson());
    //map타입으로 변경
    Response response = await _userProvider.login(loginReqDto.toJson());
    print('gewgg ${response.headers}');

    dynamic headers = response.headers;
    print(headers);
    String token = headers["authorization"];
    return token;
  }

  Future<void> register(
      String username, String password, String name, String email) async {
    //Map형태로 데이터 바꾸기 위해(Json이 Map 형태이기 때문)
    SignupReqDto signupReqDto = SignupReqDto(username, password, name, email);
    Response response = await _userProvider.register(signupReqDto.toJson());
    print(response.headers);
  }
}
