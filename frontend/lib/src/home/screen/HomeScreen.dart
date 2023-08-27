import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/home/widget/categoryIconWidget.dart';
import 'package:frontend/src/product/model/list_product_model.dart';
import 'package:frontend/src/product/model/product_info_model.dart';
import 'package:frontend/src/product/screen/ProductInfoScreen.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '좋은 저녁 입니다.',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                        const Text('오늘의 메뉴는 한식 어떤가요?')
                      ]),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  child: FutureBuilder<List<ListProduct>?>(
                    future: _fetchGetMainProductData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('데이터 불러오는데 실패'));
                      } else if (snapshot.hasData) {
                        List<ListProduct> posts = snapshot.data!;

                        return CarouselSlider(
                          options: CarouselOptions(
                            height: 400,
                            aspectRatio: 3 / 2,
                            initialPage: 0,
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            enableInfiniteScroll: true,
                            pauseAutoPlayOnTouch: true,
                          ),
                          items: posts.asMap().entries.map((entity) {
                            var post = entity.value;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductInfoScreen(
                                            postId: post.id,
                                            storeId: post.storeId,
                                            heroTag: entity.key)));
                              },
                              child: Builder(
                                builder: (BuildContext context) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                            child: Image.network(post.image!,
                                                width: 40, height: 40),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(post.storeName),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: Image.network(
                                          post.image!,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(post.title),
                                              const SizedBox(width: 20),
                                              Text(
                                                '재고 떨이중',
                                                style: TextStyle(
                                                    color: Colors.red[300]),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${post.fixedPrice}',
                                                    style: const TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '${post.salePrice}',
                                                    style: TextStyle(
                                                        color: Colors.red[300]),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Text(
                                                    '${(100 - ((post.salePrice / post.fixedPrice) * 100)).floor()}%',
                                                    style: TextStyle(
                                                        color: Colors.red[300],
                                                        fontSize: 25),
                                                  ),
                                                ],
                                              ),
                                              Text('${post.capacity}개 남음')
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return const Center(child: Text('상품이 없습니다.'));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Offers Near you',
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: FutureBuilder<List<ListProduct>?>(
                        future: _fetchGetSecondProductData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('데이터 불러오는데 실패'));
                          } else if (snapshot.hasData) {
                            List<ListProduct> posts = snapshot.data!;

                            return SizedBox(
                              height: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  return makeCard(
                                      context: context,
                                      postId: posts[index].id,
                                      storeId: posts[index].storeId,
                                      image: posts[index].image!,
                                      heroTag: index);
                                },
                              ),
                            );
                          } else {
                            return const Center(child: Text('상품이 없습니다.'));
                          }
                        },
                      ),
                    ),
                    const Text('New & Trending',
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: FutureBuilder<List<ListProduct>?>(
                        future: _fetchGetSecondProductData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('데이터 불러오는데 실패'));
                          } else if (snapshot.hasData) {
                            List<ListProduct> posts = snapshot.data!;

                            return SizedBox(
                              height: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  return makeCard(
                                      context: context,
                                      postId: posts[index].id,
                                      storeId: posts[index].storeId,
                                      image: posts[index].image!,
                                      heroTag: index);
                                },
                              ),
                            );
                          } else {
                            return const Center(child: Text('상품이 없습니다.'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeCard({
    context,
    image,
    postId,
    storeId,
    heroTag,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductInfoScreen(
                    postId: postId, storeId: storeId, heroTag: heroTag)));
      },
      child: AspectRatio(
        aspectRatio: 5 / 6,
        child: Container(
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Image.network(
              image,
            ),
          ),
        ),
      ),
    );
  }

  Future<List<ListProduct>?> _fetchGetMainProductData() async {
    final Dio dio = Dio();
    try {
      final response = await dio
          .get('http://10.0.2.2:3000/api/post?orderBy=created_at&order=DESC');

      if (response.statusCode == 200) {
        final List<dynamic> posts = response.data['data'];

        //logger.d(posts);

        return posts.map((json) => ListProduct.fromJson(json)).toList();
      } else {
        print('데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
    return null;
  }

  Future<List<ListProduct>?> _fetchGetSecondProductData() async {
    final Dio dio = Dio();
    try {
      final response = await dio
          .get('http://10.0.2.2:3000/api/post?orderBy=created_at&order=DESC');

      if (response.statusCode == 200) {
        final List<dynamic> posts = response.data['data'];

        //logger.d(posts);

        return posts.map((json) => ListProduct.fromJson(json)).toList();
      } else {
        print('데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
    return null;
  }
}
