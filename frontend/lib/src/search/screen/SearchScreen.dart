import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/product/model/list_product_model.dart';
import 'package:frontend/src/product/screen/ProductInfoScreen.dart';
import 'package:image_picker/image_picker.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Dio _dio = Dio();
  List<ListProduct> _products = [];

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text('상품 검색'), backgroundColor: Colors.black),
        body: Column(
          children: [
            SizedBox(
              child: TextField(
                textInputAction: TextInputAction.go,
                onSubmitted: (value) async {
                  _products = await _getSearchProducts(value);
                  setState(() {});
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Padding(
                        padding: EdgeInsets.only(left: 13),
                        child: Icon(Icons.search))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductInfoScreen(
                                postId: _products[index].id,
                                storeId: _products[index].storeId,
                                heroTag: index)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Hero(
                              tag: index,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _products[index].image!,
                                  width: 180,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  Text(
                                    _products[index].title,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${_products[index].title}원',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            )
          ],
        ));
  }

  Future<List<ListProduct>> _getSearchProducts(String title) async {
    try {
      final response =
          await _dio.get('http://10.0.2.2:3000/api/post/search?title=$title');
      // 위 URL은 JSONPlaceholder에서 가짜 데이터를 제공하는 것입니다. 실제 서버 URL로 대체하시기 바랍니다.

      if (response.statusCode == 200) {
        final List<dynamic> produts = response.data['data'];

        print(produts);
        return produts.map((json) => ListProduct.fromJson(json)).toList();
      } else {
        print('데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
    return [];
  }
}
