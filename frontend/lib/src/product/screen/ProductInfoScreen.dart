import 'dart:async';

import 'package:dio/dio.dart';
import 'package:frontend/src/account/state/AuthState.dart';
import 'package:frontend/src/account/widget/TextFieldWidget.dart';
import 'package:frontend/src/product/model/product_info_model.dart';
import 'package:frontend/src/product/model/store_model.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/product/model/list_product_model.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProductInfoScreen extends StatefulWidget {
  final String postId;
  final int storeId;
  final int heroTag;

  const ProductInfoScreen({
    super.key,
    required this.postId,
    required this.storeId,
    required this.heroTag,
  });

  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  var logger = Logger();
  final _formKey = GlobalKey<FormState>();
  late EdgeInsets safeArea;
  double drawerHeight = 0;
  bool a = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    safeArea = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.black)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home, color: Colors.black))
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: _fetchGetStoreData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('데이터 불러오는데 실패'));
          } else if (snapshot.hasData) {
            Store store = snapshot.data!;

            return SlidingUpPanel(
              minHeight: 45,
              maxHeight: 600,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              collapsed: const Center(child: Text('가게 정보')),
              panel: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text('상호명: ${store.storeName}'),
                    Text('주소: ${store.address}'),
                    const Text('전화번호: 010-1111-222'),
                    SizedBox(
                      width: 400,
                      height: 300,
                      child: mapWidget(
                        store.latitude,
                        store.longitude,
                      ),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: FutureBuilder<PostInfo?>(
                    future: _fetchGetProductData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('데이터 불러오는데 실패'));
                      } else if (snapshot.hasData) {
                        PostInfo post = snapshot.data!;

                        return Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Hero(
                                tag: widget.heroTag,
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Image.network(post.image!,
                                          fit: BoxFit.fill),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 20, right: 30),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 제목, 상호명, 재고 컨테이너
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post.title,
                                                  style: const TextStyle(
                                                      fontSize: 25),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  '상호명: ${post.storeName}',
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                )
                                              ],
                                            ),
                                            Text(
                                              '재고: ${post.capacity}개',
                                              style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 15),
                                            ),
                                          ]),
                                      const SizedBox(height: 30),
                                      // 원가, 판매가 컨테이너
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '원가 : ${post.fixedPrice}원',
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    '${(100 - ((post.salePrice / post.fixedPrice) * 100)).floor()}%',
                                                    style: const TextStyle(
                                                        color: Colors.orange,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '판매가: ${post.salePrice}원',
                                                style: const TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(children: [
                                            Text(
                                              '제조년월: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(post.manufactureDate))}',
                                            ),
                                            Text(
                                              '소비기한: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(post.expirationDate))}',
                                            )
                                          ]),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.orange[100]),
                                            width: 160,
                                            height: 50,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              '+ 상품정보 더보기',
                                              style: TextStyle(
                                                  color: Colors.orange),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300]),
                                      width: double.infinity,
                                      height: 50,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 20),
                                      child: const Text(
                                        '상품정보',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Text(
                                        post.description,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // SizedBox(
                                    //   width: 400,
                                    //   height: 300,
                                    //   child: mapWidget(
                                    //     post.storeLatitude,
                                    //     post.storeLongitude,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                width: double.infinity,
                                height: 80,
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.favorite_border),
                                      ),
                                      Container(
                                        width: 200,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.red[300],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            '${post.salePrice}원',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        );
                      } else {
                        return const Center(child: Text('상품이 없습니다.'));
                      }
                    },
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('상품이 없습니다.'));
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  late NaverMapController mapController;
  NaverMapViewOptions options = const NaverMapViewOptions();
  late double latitued;
  late double lontitued;
  Widget mapWidget(latitude, longtitued) {
    final mapPadding = EdgeInsets.only(bottom: drawerHeight - safeArea.bottom);
    latitued = latitude;
    lontitued = longtitued;

    return NaverMap(
      options: options.copyWith(
          contentPadding: mapPadding,
          initialCameraPosition:
              NCameraPosition(target: NLatLng(latitued, lontitued), zoom: 15)),
      onMapReady: onMapReady,
      onMapTapped: onMapTapped,
      onSymbolTapped: onSymbolTapped,
      onCameraChange: onCameraChange,
      onCameraIdle: onCameraIdle,
      onSelectedIndoorChanged: onSelectedIndoorChanged,
    );
  }

  void onMapReady(NaverMapController controller) {
    mapController = controller;

    final marker = NMarker(id: "test", position: NLatLng(latitued, lontitued));
    controller.addOverlay(marker);
  }

  void onMapTapped(NPoint point, NLatLng latLng) {
    // ...
  }

  void onSymbolTapped(NSymbolInfo symbolInfo) {
    // ...
  }

  void onCameraChange(NCameraUpdateReason reason, bool isGesture) {}

  void onCameraIdle() {}

  void onSelectedIndoorChanged(NSelectedIndoor? selectedIndoor) {
    // ...
  }

  Future<PostInfo?> _fetchGetProductData() async {
    final Dio dio = Dio();

    try {
      String postId = widget.postId;

      final response = await dio.get('http://10.0.2.2:3000/api/post/$postId');

      if (response.statusCode == 200) {
        final dynamic product = response.data['data'];

        //logger.d(product);
        return PostInfo.fromJson(product);
      } else {
        print('데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
    return null;
  }

  Future<Store?> _fetchGetStoreData() async {
    final Dio dio = Dio();

    try {
      int soreId = widget.storeId;

      final response = await dio.get('http://10.0.2.2:3000/api/store/$soreId');

      if (response.statusCode == 200) {
        final dynamic product = response.data['data'];

        logger.d(product);
        return Store.fromJson(product);
      } else {
        print('데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
    return null;
  }
}
