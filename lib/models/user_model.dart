class UserModel {
  final String? uid;

  final String? name;

  final String? email;

  UserModel({this.email, this.name, this.uid});


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
   uid: json["uid"],
   name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "email":email,
  };

}
