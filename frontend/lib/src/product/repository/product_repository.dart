import 'package:frontend/src/product/model/product_model.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  final Dio _dio = Dio();

  Future<List<Product>?> fetchProducts() async {
    try {
      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/posts/1');
      // 위 URL은 JSONPlaceholder에서 가짜 데이터를 제공하는 것입니다. 실제 서버 URL로 대체하시기 바랍니다.

      if (response.statusCode == 200) {
        print(response.data); // JSON 데이터 출력 (여기서는 콘솔에 출력하게 했습니다.)
      } else {
        print('데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
    }

    return null;
  }
}
