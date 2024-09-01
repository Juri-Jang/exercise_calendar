class User {
  final int? id;
  final String? username;
  final String? userid;
  final String? password;
  final String? email;

  User(this.id, this.userid, this.username, this.password, this.email);

  //통신을 위한 json 데이터 타입 -> dart 오브젝트
  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        password = json["password"],
        userid = json["userid"],
        username = json["username"],
        email = json["email"];
}
