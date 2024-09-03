import 'package:exercise_calendar/controller/dto/SignupReqDto.dart';
import 'package:exercise_calendar/domain/user/user_provider.dart';
import 'package:get/get_connect/http/src/response/response.dart';

//통신을 호출해서 응답되는 데이터를 예쁘게 가공 (json => dart오브젝트 )
class UserRepository {
  final UserProvider _userProvider = UserProvider();

  Future<void> register(
      String username, String userid, String password, String email) async {
    //Map형태로 데이터 바꾸기 위해(Json이 Map 형태이기 때문)
    SignupReqDto signupReqDto = SignupReqDto(username, userid, password, email);
    print("==========");
    print(signupReqDto.toJson());

    Response response = await _userProvider.register(signupReqDto.toJson());
    print("==========");
    print(response.body);
    print("==========");
    print(response.headers);
  }
}
