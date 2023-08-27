import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/account/model/SignUp_model.dart';
import 'package:frontend/src/account/screen/LoginScreen.dart';
import 'package:frontend/src/account/state/AuthState.dart';
import 'package:frontend/src/account/widget/TextFieldWidget.dart';
import 'package:frontend/src/common/utils/message.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var logger = Logger();
  final Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Sign Up!', style: TextStyle(fontSize: 30)),
                        SizedBox(height: 10),
                        Text('Sign up or Login to your Account',
                            style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldWidget(
                          label: 'Email',
                          hintText: '이메일을 입력하세요',
                          textEditingController: emailController,
                          textInputType: TextInputType.emailAddress,
                        ),
                        TextFieldWidget(
                          label: 'Nickname',
                          hintText: '닉네임을 입력하세요',
                          textEditingController: nicknameController,
                        ),
                        TextFieldWidget(
                          label: 'Password',
                          hintText: '비밀번호를 입력하세요',
                          obscureText: true,
                          textEditingController: passwordController,
                        ),
                        TextFieldWidget(
                          label: 'Password Confirm',
                          hintText: '비밀번호 확인을 입력하세요',
                          obscureText: true,
                          textEditingController: passwordConfirmController,
                        ),
                        TextFieldWidget(
                          label: 'Phone',
                          hintText: '휴대폰 번호를 입력하세요',
                          textEditingController: phoneController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        _signup(context);
                      },
                      child: const Text('Sign Up',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signup(BuildContext context) async {
    final authState = Provider.of<AuthState>(context, listen: false);

    if (_formKey.currentState!.validate() == false) return;

    try {
      final createUser = SignUp(
        email: emailController.text,
        nickname: nicknameController.text,
        password: passwordController.text,
        phone: phoneController.text,
      );

      Response response = await dio.post(
          'http://10.0.2.2:3000/api/auth/user/signup',
          data: createUser.toJson());
      int statusCode = response.data['statusCode'];

      if ((statusCode == 200) || (statusCode == 201)) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else if (statusCode == 400) {
        String errorMessage = response.data['message'];

        showToast(errorMessage);
      }
    } catch (e) {
      logger.e(e);
    }
    return;
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
