class User {
  final int? id;
  final String? username;
  final String? password;
  final String? name;
  final String? email;

  User(this.id, this.username, this.password, this.name, this.email);

  //통신을 위한 json 데이터 타입 -> dart 오브젝트
  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"],
        password = json["password"],
        name = json["name"],
        email = json["email"];
}
