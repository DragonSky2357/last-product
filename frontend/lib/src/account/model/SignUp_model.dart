class SignUp {
  final String email;
  final String password;
  final String nickname;
  final String phone;

  SignUp(
      {required this.email,
      required this.password,
      required this.nickname,
      required this.phone});

  factory SignUp.fromJson(Map<String, dynamic> json) {
    return SignUp(
      email: json['email'],
      password: json['password'],
      nickname: json['nickname'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nickname': nickname,
      'phone': phone,
    };
  }
}
