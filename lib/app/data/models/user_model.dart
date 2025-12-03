class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final num? credits;
  final bool? hasSpunToday;

  UserModel({this.name, this.email, this.credits, this.hasSpunToday, this.id});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      credits: num.tryParse(json["credits"].toString()) ?? 0.0,
      hasSpunToday: json["hasSpunToday"] ?? false,
    );
  }
}
