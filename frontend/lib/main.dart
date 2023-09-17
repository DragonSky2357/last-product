import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:frontend/src/account/state/AuthState.dart';
import 'package:frontend/src/account/screen/LoginScreen.dart';
import 'package:frontend/src/main/screen/MainScreen.dart';
import 'package:provider/provider.dart';
import 'package:kpostal/kpostal.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env');
  await NaverMapSdk.instance.initialize(
      clientId: 'vbi897aazw',
      onAuthFailed: (error) {
        print('Auth failed: $error');
      });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthState())],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ko', 'KR'), // 한국어
          Locale('en', 'US'), // 영어
        ],
        title: 'My App',
        home: Main(),
      ),
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

    if (authState.isLoggedIn) {
      return ChangeNotifierProvider(
          create: (context) => AuthState(),
          child: const Scaffold(body: MainScreen()));
    } else {
      return const LoginScreen();
    }
  }
}
