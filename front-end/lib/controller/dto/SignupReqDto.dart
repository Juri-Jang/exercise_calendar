class SignupReqDto {
  final String? username;
  final String? password;
  final String? name;
  final String? email;

  SignupReqDto(this.username, this.password, this.name, this.email);

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "name": name,
        "email": email
      };
}
