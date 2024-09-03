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
        username = json["username"],
        userid = json["userid"],
        password = json["password"],
        email = json["email"];
}
