import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey[100]),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'user님',
                        style: TextStyle(fontSize: 25),
                      ),
                      Image.network(
                        'https://mblogthumb-phinf.pstatic.net/20160426_243/ppanppane_1461649969412i4kz1_PNG/%C6%C4%B8%AE%B9%D9%B0%D4%C6%AE_%B7%CE%B0%ED_%281%29.png?type=w800',
                        width: 50,
                        height: 50,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('이번달로 떨이요로 총 40,000원 절약하셨어요!'),
                ),
                const SizedBox(height: 40),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [Text('구매내역'), Text('20')],
                      ),
                      Column(
                        children: [Text('리뷰'), Text('20')],
                      ),
                      Column(
                        children: [Text('장바구니'), Text('20')],
                      ),
                      Column(
                        children: [Text('자주산상품'), Text('20')],
                      ),
                    ]),
                const SizedBox(height: 50),
                const Column(children: [
                  Row(
                    children: [
                      Icon(Icons.list, size: 40),
                      SizedBox(width: 5),
                      Text('구매내역', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(
                    width: 500,
                    child: Divider(color: Colors.black, thickness: 1.0),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star_border, size: 40),
                      SizedBox(width: 5),
                      Text('리뷰내역', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(
                    width: 500,
                    child: Divider(color: Colors.black, thickness: 1.0),
                  ),
                  Row(
                    children: [
                      Icon(Icons.shopping_cart_rounded, size: 40),
                      SizedBox(width: 5),
                      Text('구매내역', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(
                    width: 500,
                    child: Divider(color: Colors.black, thickness: 1.0),
                  ),
                  Row(
                    children: [
                      Icon(Icons.question_mark, size: 40),
                      SizedBox(width: 5),
                      Text('고객센터', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(
                    width: 500,
                    child: Divider(color: Colors.black, thickness: 1.0),
                  )
                ]),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Image.network(
                      'https://simage.lottemart.com/lim/static_root/images/onlinedescr/images/001589/%EC%A7%84%EB%9D%BC%EB%A9%B4_%ED%8F%AC%EC%8A%A4%ED%84%B0_%EC%B5%9C%EC%A2%85_7.jpg',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
