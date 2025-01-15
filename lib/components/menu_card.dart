import 'package:flutter/material.dart';
import 'package:hello_flutter/theme/colors.dart';

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
      height: 270,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 20), // 간격
      decoration: BoxDecoration(
        color: AppColors.primaryGreen, // 배경색
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
          Expanded(
            child: Transform.translate(
              offset: Offset(-30, 0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), // 둥근 모서리
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // 그림자 색상
                          blurRadius: 10, // 그림자 퍼짐 정도
                          offset: Offset(4, 4), // 그림자 위치 (x, y)
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity, // 부모 너비에 맞춤
                        height: double.infinity, // 부모 높이에 맞춤
                        fit: BoxFit.cover, // 이미지 크기를 부모 영역에 맞춤
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              '이미지를 불러올 수 없습니다.',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 텍스트 섹션
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity, // Column의 전체 너비 사용
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.right, // 중앙 정렬
                    maxLines: 2, // 최대 2줄 허용
                    overflow: TextOverflow.ellipsis, // 넘치는 텍스트 생략
                    softWrap: true, // 줄바꿈 허용
                  ),
                ),
                SizedBox(height: 2),
                SizedBox(
                  width: double.infinity, // Column의 전체 너비 사용
                  child: Text(
                    price,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.right, // 중앙 정렬
                    maxLines: 2, // 최대 2줄 허용
                    overflow: TextOverflow.ellipsis, // 넘치는 텍스트 생략
                    softWrap: true, // 줄바꿈 허용
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < 5; i++) // 5개의 별
                      Icon(
                        Icons.star,
                        size: 16,
                        color: i < rating.floor()
                            ? AppColors.accentPrimaryMainDandelion
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
          ),
          // 별점 섹션
        ],
      ),
    );
  }
}
