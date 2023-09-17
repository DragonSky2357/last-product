import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frontend/src/account/state/AuthState.dart';
import 'package:frontend/src/product/model/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kpostal/kpostal.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var logger = Logger();
  final Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final picker = ImagePicker();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateTime _manufatureDate = DateTime.now();
  DateTime _expirationDate = DateTime.now();

  String _title = '';
  String _description = '';
  int _capacity = 0;
  int _fixedPrice = 0;
  int _salePrice = 0;

  late EdgeInsets safeArea;
  double drawerHeight = 0;

  @override
  Widget build(BuildContext context) {
    safeArea = MediaQuery.of(context).padding;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: _selectedImageFromGallery,
                      child: SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: _selectedImage != null
                            ? Image.file(
                                fit: BoxFit.cover,
                                _selectedImage!,
                              )
                            : const Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, size: 50),
                                  Text('클릭해서 사진등록')
                                ],
                              )),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
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
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                textAlign: TextAlign.end,
                                decoration:
                                    const InputDecoration(hintText: "판매가격"),
                                style: Theme.of(context).textTheme.bodyMedium,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '판매가격을 입력해주세요';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _fixedPrice = int.parse(value);
                                },
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                decoration:
                                    const InputDecoration(hintText: "세일가격"),
                                style: Theme.of(context).textTheme.bodyMedium,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '세일가격을 입력해주세요';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _salePrice = int.parse(value);
                                },
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                textAlign: TextAlign.end,
                                decoration:
                                    const InputDecoration(hintText: "수량"),
                                style: Theme.of(context).textTheme.bodyMedium,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '수량을 입력해주세요';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _capacity = int.parse(value);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final selectedDate = await showDatePicker(
                                      context: context,
                                      locale: const Locale('ko', 'KR'),
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2040),
                                    );

                                    if (selectedDate != null) {
                                      setState(() {
                                        _manufatureDate = selectedDate;
                                      });
                                    }
                                  },
                                  child: const Text('제조일자'),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(
                                          _manufatureDate.toString())),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final selectedDate = await showDatePicker(
                                      context: context,
                                      locale: const Locale('ko', 'KR'),
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2040),
                                    );

                                    if (selectedDate != null) {
                                      setState(() {
                                        _expirationDate = selectedDate;
                                      });
                                    }
                                  },
                                  child: const Text('유통기한'),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(
                                          _expirationDate.toString())),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   width: double.infinity,
                        //   height: 80,
                        //   child: TextButton(
                        //     onPressed: () async {
                        //       Kpostal result = await Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (_) => KpostalView()));
                        //       setState(() {
                        //         _address = result.address;
                        //         _latitude = result.latitude!;
                        //         _longitude = result.longitude!;
                        //       });
                        //     },
                        //     child: const Text('주소 검색'),
                        //   ),
                        // ),
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

  void _fetchRegisterProduct(BuildContext context) async {
    final authState = Provider.of<AuthState>(context, listen: false);

    List<int> compressedImage = (await FlutterImageCompress.compressWithFile(
      _selectedImage!.path,
      quality: 70,
    )) as List<int>;

    final product = Product(
      title: _title,
      description: _description,
      image: _selectedImage,
      fixedPrice: _fixedPrice,
      salePrice: _salePrice,
      manufactureDate: _manufatureDate,
      expirationDate: _expirationDate,
    );

    String? token = authState.getToken;

    Map<String, dynamic> headers = {
      'Authorization':
          'Bearer $token', // 여기서 YOUR_ACCESS_TOKEN에 실제 토큰 값을 입력해야 합니다.
      'Content-Type': 'multipart/form-data', // 필요한 헤더들을 추가할 수 있습니다.
    };

    var formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(compressedImage, filename: 'image.jpg'),
      'title': _title,
      'description': _description,
      'product': {
        'capacity': _capacity,
        'fixed_price': _fixedPrice,
        'sale_price': _salePrice,
        'manufacture_date': _manufatureDate,
        'expiration_date': _expirationDate,
      }
    });

    try {
      final response = await dio.post('${dotenv.env['BASE_URL']}/post',
          options: Options(headers: headers), data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 상품 등록에 성공한 경우
        logger.d('상품 등록 성공!');
        Navigator.pop(context);
      } else {
        logger.d('상품 등록 실패. 에러 코드: ${response.statusCode}');
        logger.d(product.toJson());
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<List<Product>?> _fetchData() async {
    try {
      final response = await dio.get('${dotenv.env['BASE_URL']}/product');
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
