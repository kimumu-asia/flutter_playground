import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final double rating;

  const MenuCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // 카드 너비
      height: 250,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 20), // 간격
      decoration: BoxDecoration(
        color: Color(0xff1CAE81), // 배경색
        borderRadius: BorderRadius.circular(20), // 둥근 모서리
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // 그림자 색상
            blurRadius: 6, // 흐림 정도
            offset: Offset(0, 3), // 위치
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 이미지 섹션
          ClipRRect(
            borderRadius: BorderRadius.circular(100), // 둥근 모서리로 잘라냄
            child: Image.network(
              imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover, // 이미지 채우기
            ),
          ),
          SizedBox(height: 10), // 간격
          // 텍스트 섹션
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 4),
          // 별점 섹션
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 5; i++) // 5개의 별
                Icon(
                  Icons.star,
                  size: 16,
                  color: i < rating.floor()
                      ? Color(0xffFFC107)
                      : Colors.white60, // 별 채우기
                ),
              SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class FoodCardList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Food Cards")),
//       body: Center(
//         child: ListView(
//           scrollDirection: Axis.horizontal, // 가로 스크롤
//           children: [
//             FoodCard(
//               imageUrl:
//                   'https://example.com/chicken.jpg', // 치킨 이미지 URL
//               title: '후라이드 치킨',
//               price: '18,000원',
//               rating: 4.9,
//             ),
//             FoodCard(
//               imageUrl:
//                   'https://example.com/tteokbokki.jpg', // 떡볶이 이미지 URL
//               title: '떡볶이',
//               price: '12,000원',
//               rating: 4.5,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }