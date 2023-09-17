import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/src/product/model/list_product_model.dart';
import 'package:frontend/src/product/model/product_model.dart';
import 'package:frontend/src/product/repository/product_repository.dart';
import 'package:frontend/src/product/screen/ProductInfoScreen.dart';
import 'package:logger/logger.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var logger = Logger();
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 목록'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<ListProduct>?>(
        future: _fetchData(),
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

  @override
  void initState() {
    super.initState();
  }

  Future<List<ListProduct>?> _fetchData() async {
    try {
      final response = await _dio.get('${dotenv.env['BASE_URL']}/post');
      // 위 URL은 JSONPlaceholder에서 가짜 데이터를 제공하는 것입니다. 실제 서버 URL로 대체하시기 바랍니다.

      logger.d(response.data);
      if (response.statusCode == 200) {
        logger.d(response.data['data']);
        final List<dynamic> produts = response.data['data'];

        logger.d(produts);

        return produts.map((json) => ListProduct.fromJson(json)).toList();
      } else {
        print('데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
    return null;
  }
}
