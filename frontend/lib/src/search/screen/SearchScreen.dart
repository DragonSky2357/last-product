import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/src/product/model/list_product_model.dart';
import 'package:frontend/src/product/screen/ProductInfoScreen.dart';

class SearchScreen extends StatefulWidget {
  final String searchText;

  const SearchScreen(this.searchText, {super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상품 검색'), backgroundColor: Colors.black),
      body: FutureBuilder<List<ListProduct>?>(
        future: _getSearchProducts(widget.searchText),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('데이터 불러오는데 실패'));
          } else if (snapshot.hasData) {
            List<ListProduct> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Transform.scale(
                    scale: 1.2,
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(products[index].image!)),
                      ),
                    ),
                  ),
                  title: Text(products[index].title,
                      style: const TextStyle(color: Colors.black)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${products[index].fixedPrice}원',
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough)),
                          const SizedBox(width: 10),
                          Text('${products[index].salePrice}원',
                              style: TextStyle(color: Colors.red[300])),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('재고 ${products[index].capacity}개 남음',
                          style: TextStyle(color: Colors.red[300])),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_right_sharp),
                  shape: const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductInfoScreen(
                                postId: products[index].id,
                                storeId: products[index].storeId,
                                heroTag: index)));
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('상품이 없습니다.'));
          }
        },
      ),
    );
  }

  Future<List<ListProduct>> _getSearchProducts(String title) async {
    try {
      final response =
          await _dio.get('${dotenv.env['BASE_URL']}/post/search?title=$title');
      // 위 URL은 JSONPlaceholder에서 가짜 데이터를 제공하는 것입니다. 실제 서버 URL로 대체하시기 바랍니다.

      if (response.statusCode == 200) {
        final List<dynamic> produts = response.data['data'];

        print(response.data['data']);
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
