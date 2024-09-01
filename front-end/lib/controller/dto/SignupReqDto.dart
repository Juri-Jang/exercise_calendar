class SignupReqDto {
  final String? userid;
  final String? username;
  final String? password;
  final String? email;

  SignupReqDto(this.userid, this.username, this.password, this.email);

  Map<String, dynamic> toJson() =>
      {"username": username, "password": password, "email": email};
}
