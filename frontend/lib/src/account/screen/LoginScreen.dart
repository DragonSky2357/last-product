import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/account/screen/SignupScreen.dart';
import 'package:frontend/src/account/state/AuthState.dart';
import 'package:frontend/src/account/model/Login_model.dart';
import 'package:frontend/src/account/widget/SignupWidget.dart';
import 'package:frontend/src/account/widget/TextFieldWidget.dart';
import 'package:frontend/src/common/utils/message.dart';
import 'package:frontend/src/main/screen/MainScreen.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var logger = Logger();
  final Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('WelCome!', style: TextStyle(fontSize: 30)),
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        label: 'Password',
                        hintText: '비밀번호를 입력하세요',
                        obscureText: true,
                        textEditingController: passwordController,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: const Text('회원가입'),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => const SignupScreen()));
                              },
                            ),
                            TextButton(
                              child: const Text('비밀번호를 잊으셨나요?'),
                              onPressed: () {},
                            ),
                          ],
                        )),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () {
                          _login(context);
                        },
                        child: const Text('Login',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 60),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Or Login Using:',
                              style: TextStyle(fontSize: 15)),
                          SizedBox(
                              width: 250,
                              child:
                                  Divider(color: Colors.grey, thickness: 1.0))
                        ]),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Image.asset('assets/icons/kako_logo.png'),
                            iconSize: 50,
                            onPressed: () {}),
                        IconButton(
                            icon: Image.asset('assets/icons/google_logo.png'),
                            iconSize: 50,
                            onPressed: () {}),
                        IconButton(
                            icon: Image.asset('assets/icons/naver_logo.png'),
                            iconSize: 50,
                            onPressed: () {}),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final authState = Provider.of<AuthState>(context, listen: false);

    if (_formKey.currentState!.validate() == false) return;

    try {
      final createUser = Login(
        email: emailController.text,
        password: passwordController.text,
      );

      Response response = await dio.post(
          'http://10.0.2.2:3000/api/auth/user/login',
          data: createUser.toJson());
      int statusCode = response.data['statusCode'];

      if ((statusCode == 200) || (statusCode == 201)) {
        authState.login(response.data['data']);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen()));
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
