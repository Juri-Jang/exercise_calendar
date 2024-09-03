class SignupReqDto {
  final String? username;
  final String? userid;
  final String? password;
  final String? email;

  SignupReqDto(this.username, this.userid, this.password, this.email);

  Map<String, dynamic> toJson() => {
        "username": username,
        "userid": userid,
        "password": password,
        "email": email
      };
}
