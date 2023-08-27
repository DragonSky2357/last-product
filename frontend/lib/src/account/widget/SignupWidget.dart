// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:frontend/src/account/model/SignUp_model.dart';
// import 'package:frontend/src/account/screen/LoginScreen.dart';
// import 'package:frontend/src/account/widget/TextfieldWidget.dart';
// import 'package:frontend/src/common/utils/message.dart';
// import 'package:logger/logger.dart';

// class SignupWidget extends StatefulWidget {
//   const SignupWidget({super.key});

//   @override
//   State<SignupWidget> createState() => _SignupWidgetState();
// }

// class _SignupWidgetState extends State<SignupWidget> {
//   var logger = Logger();
//   final Dio dio = Dio();
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController nicknameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController passwordConfirmController =
//       TextEditingController();
//   final TextEditingController phoneController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: Column(
//         children: [
//           Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFieldWidget(
//                     label: 'Email Address',
//                     hintText: 'Enter your email',
//                     textEditingController: emailController),
//                 TextFieldWidget(
//                   label: 'Password',
//                   hintText: 'Enter your password',
//                   obscureText: true,
//                   textEditingController: passwordController,
//                 ),
//                 TextFieldWidget(
//                   label: 'Password Confirm',
//                   hintText: 'Enter your password',
//                   obscureText: true,
//                   textEditingController: passwordConfirmController,
//                 ),
//                 TextFieldWidget(
//                     label: 'Nick name',
//                     hintText: 'Enter your Nick Name',
//                     textEditingController: nicknameController),
//                 TextFieldWidget(
//                   label: 'Phone Number',
//                   hintText: '000-0000-0000',
//                   textEditingController: phoneController,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(20)),
//                   child: TextButton(
//                     onPressed: () {
//                       signup(context);
//                     },
//                     child: const Text('SignUp',
//                         style: TextStyle(fontSize: 20, color: Colors.white)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> signup(BuildContext context) async {
//     if (_formKey.currentState!.validate() == false) return;

//     final createUser = SignUp(
//         email: emailController.text,
//         nickname: nicknameController.text,
//         password: passwordController.text,
//         phone: phoneController.text);

//     try {
//       final response = await dio.post('http://10.0.2.2:3000/api/auth/signup',
//           data: createUser.toJson());

//       int statusCode = response.data['statusCode'];

//       if ((statusCode == 200) || (statusCode == 201)) {
//         String message = "회원 가입 성공";
//         showToast(message);
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (_) => const LoginScreen()));
//       } else {
//         String message = response.data['message'];
//         showToast(message);
//       }
//     } catch (e) {
//       print('오류 발생: $e');
//     }
//     return;
//   }
// }
