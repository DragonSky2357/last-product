class SignUpModel {
  final String email;
  final String password;
  final String nickname;
  final String birth;
  final String phone;

  SignUpModel(
      {required this.email,
      required this.password,
      required this.nickname,
      required this.birth,
      required this.phone});

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      email: json['email'],
      password: json['password'],
      nickname: json['nickname'],
      birth: json['birth'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nickname': nickname,
      'birth': birth,
      'phone': phone,
    };
  }
}
