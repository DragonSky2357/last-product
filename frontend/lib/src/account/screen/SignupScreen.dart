import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/src/account/model/SignUp_model.dart';
import 'package:frontend/src/account/screen/LoginScreen.dart';
import 'package:frontend/src/account/screen/PersonalSettingsScreen.dart';
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
  final TextEditingController birthController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final String _selectedYear = DateTime.now().year.toString();
  final String _selectedMonth = DateTime.now().month.toString();
  final String _selectedDay = DateTime.now().day.toString();

  final List<String> _years = List.generate(
      100, (int index) => (DateTime.now().year - 99 + index).toString());
  final List<String> _months =
      List.generate(12, (int index) => (index + 1).toString());
  final List<String> _days =
      List.generate(31, (int index) => (index + 1).toString());

  @override
  void initState() {
    super.initState();
  }

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
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.topLeft,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('회원가입', style: TextStyle(fontSize: 30)),
                          SizedBox(height: 10),
                          Text('지갑을 아낄수있게 도와드릴게요',
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFieldWidget(
                            label: '이메일',
                            prefixIcon: Icons.account_circle_rounded,
                            hintText: '여기에 이메일 입력',
                            textEditingController: emailController,
                            textInputType: TextInputType.emailAddress,
                          ),
                          TextFieldWidget(
                            label: '비밀번호',
                            prefixIcon: Icons.lock_outline_sharp,
                            hintText: '비밀번호를 입력',
                            obscureText: true,
                            textEditingController: passwordController,
                          ),
                          TextFieldWidget(
                            label: '비밀번호 재입력',
                            prefixIcon: Icons.lock_outline_sharp,
                            hintText: '비밀번호 입력',
                            obscureText: true,
                            textEditingController: passwordConfirmController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget(
                            label: '이름',
                            prefixIcon: Icons.account_circle_rounded,
                            hintText: '여기에 이름 입력',
                            textEditingController: nicknameController,
                          ),
                          TextFieldWidget(
                            label: '생년월일',
                            prefixIcon: Icons.date_range_outlined,
                            hintText: '여기에 생년월일',
                            textEditingController: birthController,
                          ),
                          TextFieldWidget(
                            label: '휴대폰',
                            prefixIcon: Icons.phone_android_outlined,
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
                          if (_formKey.currentState!.validate() == false) {
                            return;
                          }
                          final birth = (_selectedYear +
                              _selectedMonth.padLeft(2, '0') +
                              _selectedDay);
                          final user = SignUpModel(
                            email: emailController.text,
                            nickname: nicknameController.text,
                            password: passwordController.text,
                            birth: birth,
                            phone: phoneController.text,
                          );

                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return PersonalSettingScreen(signUp: user);
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                    position: offsetAnimation, child: child);
                              },
                            ),
                          );
                          //_signup(context);
                        },
                        child: const Text('다음',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _signup(BuildContext context) async {
    //   final authState = Provider.of<AuthState>(context, listen: false);

    //   if (_formKey.currentState!.validate() == false) return;

    //   try {
    //     final createUser = SignUp(
    //       email: emailController.text,
    //       nickname: nicknameController.text,
    //       password: passwordController.text,
    //       phone: phoneController.text,
    //     );

    //     Response response = await dio.post(
    //         '${dotenv.env['BASE_URL']}/api/auth/user/signup',
    //         data: createUser.toJson());
    //     int statusCode = response.data['statusCode'];

    //     if ((statusCode == 200) || (statusCode == 201)) {
    //       Navigator.of(context).pushReplacement(
    //           MaterialPageRoute(builder: (_) => const LoginScreen()));
    //     } else if (statusCode == 400) {
    //       String errorMessage = response.data['message'];

    //       showToast(errorMessage);
    //     }
    //   } catch (e) {
    //     logger.e(e);
    //   }
    //   return;
    // }

    // void _showDialog(String title, String message) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text(title),
    //       content: Text(message),
    //       actions: [
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           child: const Text('확인'),
    //         ),
    //       ],
    //     ),
    //   );
    // }
  }
}
