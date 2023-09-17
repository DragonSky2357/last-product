import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:frontend/src/account/model/SignUp_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PersonalSettingScreen extends StatefulWidget {
  final SignUpModel signUp;
  Position? currentPosition;
  PersonalSettingScreen({super.key, required this.signUp});

  @override
  State<PersonalSettingScreen> createState() => _PersonalSettingScreenState();
}

class _PersonalSettingScreenState extends State<PersonalSettingScreen> {
  @override
  void initState() {}

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(children: [
              Container(
                child: const Column(children: [
                  Text(
                    '개인설정',
                    style: TextStyle(fontSize: 30),
                  ),
                ]),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 400,
                height: 400,
                child: Column(children: [
                  const Text('123'),
                  FutureBuilder(
                    future: _getLocation(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: NaverMap(
                            options: NaverMapViewOptions(
                              initialCameraPosition: NCameraPosition(
                                  target: NLatLng(snapshot.data!.latitude,
                                      snapshot.data!.longitude),
                                  zoom: 17,
                                  bearing: 0,
                                  tilt: 0),
                            ),
                            forceGesture: false,
                            onMapReady: (cotroller) {
                              cotroller.addOverlay(NMarker(
                                  id: "test",
                                  position: NLatLng(snapshot.data!.latitude,
                                      snapshot.data!.longitude)));
                              print('네이버 맵 로딩');
                            },
                          ),
                        );
                      }
                    },
                  )
                ]),
              ),
              const SizedBox(height: 50),
              Container(
                child: const Column(children: [Text('좀 더 알고싶어요')]),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Future<Position> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print('위치 가져오기 오류: $e');
      rethrow;
    }
  }
}
