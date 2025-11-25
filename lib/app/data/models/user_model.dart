class UserModel {
  final String? name;
  final String? email;
  final num? credits;

  UserModel({this.name, this.email, this.credits});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      credits: num.tryParse(json["credits"] ?? "0.0") ?? 0.0,
    );
  }
}
