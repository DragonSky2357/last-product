import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frontend/src/account/state/AuthState.dart';
import 'package:frontend/src/product/model/product_model.dart';
import 'package:frontend/src/product/screen/ProductScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpostal/kpostal.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final picker = ImagePicker();

  String _title = '';
  String _description = '';
  int _price = 0;
  String _address = '';
  double _latitude = 0.0;
  double _longitude = 0.0;

  late EdgeInsets safeArea;
  double drawerHeight = 0;

  @override
  Widget build(BuildContext context) {
    safeArea = MediaQuery.of(context).padding;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:
            AppBar(title: const Text('상품 등록'), backgroundColor: Colors.black),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: _selectedImageFromGallery,
                    child: SizedBox(
                      width: double.infinity,
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                            )
                          : const Center(child: Text('이미지를 선택해주세요.')),
                    )),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "상품명",
                            hintText: '상품명을 입력해주세요',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '상품명을 입력해주세요';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _title = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: TextFormField(
                          maxLines: null,
                          decoration: const InputDecoration(
                            labelText: "설명",
                            hintText: '상품 설명을 입력해주세요',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '상품 설명을 입력해주세요';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _description = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "가격",
                            hintText: '￦',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '상품명을 입력해주세요';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _price = int.parse(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: Text('주소'),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: Text(_address),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: TextButton(
                          onPressed: () async {
                            Kpostal result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => KpostalView()));
                            setState(() {
                              _address = result.address;
                              _latitude = result.latitude!;
                              _longitude = result.longitude!;
                            });
                          },
                          child: const Text('주소 검색'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _fetchRegisterProduct(context);
                        },
                        child: const Text('상품 등록'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _selectedImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _takePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _fetchRegisterProduct(BuildContext context) async {
    final authState = Provider.of<AuthState>(context, listen: false);

    List<int> compressedImage = (await FlutterImageCompress.compressWithFile(
      _selectedImage!.path,
      quality: 70,
    )) as List<int>;

    final product = Product(
        title: _title,
        description: _description,
        price: _price,
        image: _selectedImage,
        address: _address,
        latitude: _latitude,
        longitude: _longitude);

    var formData = FormData.fromMap({
      'title': _title,
      'description': _description,
      'price': _price,
      'image': MultipartFile.fromBytes(compressedImage, filename: 'image.jpg'),
      'address': _address,
      'latitude': _latitude,
      'longitude': _longitude
    });

    String? token = authState.getToken;

    Map<String, dynamic> headers = {
      'Authorization':
          'Bearer $token', // 여기서 YOUR_ACCESS_TOKEN에 실제 토큰 값을 입력해야 합니다.
      'Content-Type': 'application/json', // 필요한 헤더들을 추가할 수 있습니다.
    };

    try {
      final response = await dio.post('http://10.0.2.2:3000/api/product',
          options: Options(headers: headers), data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 상품 등록에 성공한 경우
        print('상품 등록 성공!');
        Navigator.pop(context);
      } else {
        print('상품 등록 실패. 에러 코드: ${response.statusCode}');
        print(product.toJson());
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  Future<List<Product>?> _fetchData() async {
    try {
      final response = await dio.get('http://localhost:3000/api/product');
      // 위 URL은 JSONPlaceholder에서 가짜 데이터를 제공하는 것입니다. 실제 서버 URL로 대체하시기 바랍니다.

      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      } else {
        print('데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
    return null;
  }
}
