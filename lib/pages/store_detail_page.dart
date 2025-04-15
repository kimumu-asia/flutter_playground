import 'package:flutter/material.dart';
import 'package:hello_flutter/theme/colors.dart';
import 'package:provider/provider.dart';
import '../viewModels/store_detail_view_model.dart';
import '../components/benefit_card.dart';
import '../components/menu_item_card.dart';
import '../components/menu_grid_card.dart';
import '../components/storeDetail/map_card.dart';

class StoreDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreDetailViewModel>(context).store;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 이미지와 버튼을 겹치기 위해 Stack 사용
            Stack(
              children: [
                // 가게 이미지
                SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: Image.network(
                    store['imageUrl'] ?? 'http://plus.unsplash.com/premium_photo-1679503585289-c02467981894?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cmVzdHJhdW50fGVufDB8fDB8fHww',
                    fit: BoxFit.cover,
                  ),
                ),

                // 버튼 오버레이 (fill을 사용해 전체 덮음)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 54, left: 16),
                      child: _buildCircleButton(
                        icon: Icons.chevron_left,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 54, right: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildCircleButton(icon: Icons.favorite_border, onTap: () {}),
                          SizedBox(width: 8),
                          _buildCircleButton(icon: Icons.ios_share, onTap: () {}),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 가게 상세 정보
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store['placeName'] ?? "가게 이름에 오류가 발생했어요",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "영업중 · ${ (store['placeTypeTitles'] as List<dynamic>?)?.join(', ') ?? '' }",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 정렬 문제 해결
                            children: [
                              Expanded(child: _buildInfoItem("리뷰점수", store['reviewRate']?.toString() ?? "0.0")),
                              Container(
                                height: 54,
                                child: VerticalDivider(),
                              ),
                              Expanded(child: _buildInfoItem("평균 재방문 수", store['revisitRate']?.toString() ?? "0.0")),
                              Container(
                                height: 54,
                                child: VerticalDivider(),
                              ),
                              Expanded(child: _buildInfoItem("누적 방문 수", store['visitCount']?.toString() ?? "0")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 혜택 섹션
                  SizedBox(height: 16),
                  Divider(color: Colors.grey.shade200),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "혜택 종류",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 720, // 혜택 카드 영역의 높이 설정
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (store['placeBenefits'] as List<dynamic>?)?.length ?? 0,
                      itemBuilder: (context, index) {
                        final benefits = store['placeBenefits'] as List<dynamic>? ?? [];
                        if (benefits.isEmpty) {
                          return SizedBox.shrink();
                        }
                        try {
                          final benefitData = benefits[index] as Map<String, dynamic>;
                          return BenefitCard(
                            benefit: Benefit.fromJson(benefitData),
                          );
                        } catch (e) {
                          print('Error creating Benefit: $e');
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),

                  // 메뉴 정보 섹션
                  SizedBox(height: 24),
                  Divider(color: Colors.grey.shade200),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "메뉴 정보",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ...(store['placeBenefits'] as List<dynamic>? ?? []).map((item) {
                          try {
                            return Column(
                              children: [
                                MenuItemCard(
                                  item: MenuItem(
                                    itemName: item['itemName'] ?? '짜장면',
                                    price: item['price'] ?? 15000,
                                    imageUrl: item['imageUrl'] ?? 'https://placehold.co/540x400',
                                    reviewRate: (item['reviewRate'] ?? 4.8).toDouble(),
                                    reviewCount: item['reviewCount'] ?? 23,
                                  ),
                                ),
                                SizedBox(height: 12),
                              ],
                            );
                          } catch (e) {
                            print('Error creating MenuItem: $e');
                            return SizedBox.shrink();
                          }
                        }).toList(),
                      ],
                    ),
                  ),
                  // 위치
                  SizedBox(height: 24),
                  Divider(color: Colors.grey.shade200),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "위치",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildMapCard(context),
                      ],
                    ),
                  ),

                  // 메뉴 그리드 섹션
                  SizedBox(height: 24),
                  Divider(color: Colors.grey.shade200),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "추천 메뉴",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.grey.shade200),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 공통 버튼 스타일
  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white, // 반투명 배경
        radius: 18,
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
  
  Widget _buildInfoItem(String title, String value) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard(BuildContext context) {
    final store = Provider.of<StoreDetailViewModel>(context).store;
    
    // place 키가 있는지 확인
    final place = store['place'] as Map<String, dynamic>?;
    
    if (place == null ||
        place['latitude'] == null ||
        place['longitude'] == null) {
      return const SizedBox.shrink();
    }

    return GoogleMapComponent(
      latitude: (place['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (place['longitude'] as num?)?.toDouble() ?? 0.0,
      address: place['address'] ?? '',
      addressDetail: place['addressDetail'] ?? '',
    );
  }
}
