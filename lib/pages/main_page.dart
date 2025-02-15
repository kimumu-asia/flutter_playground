import 'package:flutter/material.dart';
import 'package:hello_flutter/theme/colors.dart';

import '../components/menu_card.dart';
import '../widgets/bottom_navigation.dart';
import 'dummy_store.dart';
import 'main_map_page.dart';
import 'filter.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedCategoryIndex = 0; // 상태 관리 (상단 음식 종류 카테고리)
  int _selectedIndex = 0; // 상태 관리 (선택된 탭)
  int _bottomSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // AppBar 그림자 제거
        title: Row(
          children: [
            Expanded(
              child:Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 검색창 배경색
                  borderRadius: BorderRadius.circular(30), // 둥근 테두리
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08), // 그림자 색상
                      blurRadius: 12, // 그림자 흐림 정도
                      offset: Offset(0, 2), // 그림자 위치
                    ),
                  ],
                ),
                child: TextField(
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: '매장을 검색해 볼까요?',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // 둥근 테두리
                      borderSide: BorderSide.none, // 보더 제거
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 내부 여백
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.borderGray,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.tune, color: AppColors.textBodyGray), // 필터 아이콘 (조절 아이콘)
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilterScreen(),
                    ),
                  );

                  if (result != null) {
                    print("필터 결과: $result");
                    // TODO: 선택된 필터값을 사용하여 매장 리스트 필터링
                  }
                },
              ),
            ),
          ]
        )
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(8.0),
              children: [
                _buildCategoryItem('치킨', 0),
                _buildCategoryItem('육류', 1),
                _buildCategoryItem('족발', 2),
                _buildCategoryItem('보쌈', 3),
                _buildCategoryItem('찜', 4),
                _buildCategoryItem('탕', 5),
                _buildCategoryItem('회', 6),
                _buildCategoryItem('해물', 7),
                _buildCategoryItem('한식', 8),
                _buildCategoryItem('양식', 9),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // Body Content
                _buildBody(),

                // Custom Positioned Floating TabBar
                Positioned(
                  bottom: 20, // 하단에서 20px 위로 띄움
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.textBodyBlack,
                        borderRadius: BorderRadius.circular(24), // 둥근 모서리
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTabIcon(Icons.store, '목록', 0),
                          _buildTabIcon(Icons.map_outlined, '지도', 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (index) {
          setState(() {
            _bottomSelectedIndex = index; // 선택된 탭 상태 업데이트
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    final List<Widget> tabContents = [
      _buildStoreTab(),
      MainMap(),
    ];

    // 각 탭에 대한 내용 표시
    return Expanded(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: tabContents[_selectedIndex],
      ),
    );
  }

  Widget _buildTabIcon(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;

    if (isSelected) {
      return SizedBox.shrink(); // 선택된 경우 아무것도 표시하지 않음
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
          SizedBox(width: 6), // 배지 간 간격
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreTab() {
    // 기존의 첫 번째 탭 내용
    return Column(
      children: [
        Expanded(
          child: dummyStores['data']['stores'].isEmpty
              ? Center(
                  child: Text(
                    '매장을 찾을 수 없습니다.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(4.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 420,
                    crossAxisCount: 1,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 14.0,
                    mainAxisSpacing: 0.0,
                  ),
                  itemCount: dummyStores['data']['stores'].length,
                  itemBuilder: (context, index) {
                    final store = dummyStores['data']['stores'][index];
                    return _buildStoreCard(store);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String title, int index) {
    final bool isSelected = _selectedCategoryIndex == index;
    
    return GestureDetector(
      onTap: () {
          setState(() {
          _selectedCategoryIndex = index; // 선택된 카테고리 상태 업데이트
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 20.0, // 최소 높이
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primaryGreen : Colors.black,
                ),
              ),
              if (isSelected)
                Container(
                  margin: EdgeInsets.only(top: 4), // 텍스트와 간격
                  width: 20, // 밑줄 너비
                  height: 2, // 밑줄 두께
                  color: Colors.green, // 선택된 밑줄 색상
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    final benefitItems = store['benefitItems'] as List<dynamic>;
    final firstBenefit = benefitItems.isNotEmpty ? benefitItems[0] : null;

    return Container(
      color: Colors.white,
      child: SizedBox.expand(
        child: Column(
          children: [
            Expanded(
              child: Card(
                color: Colors.white,
                elevation: 0,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // 모서리 둥글기
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(3, (index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: MenuCard(
                              imageUrl:
                                  'http://plus.unsplash.com/premium_photo-1679503585289-c02467981894?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cmVzdHJhdW50fGVufDB8fDB8fHww',
                              title: '후라이드 치킨',
                              price: '18,000원',
                              rating: 4.9,
                            ),
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store['storeName'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '재방문률 4.2%',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 2), // 배지 간 간격
                          Text(
                            '∙한식',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff8A8D9F)),
                          ),
                          SizedBox(width: 2), // 배지 간 간격
                          Text(
                            '∙방문자 수 100명 ',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff8A8D9F)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 14.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBadge("리뷰 ${store['reviewCount']}건"),
                            SizedBox(width: 8), // 배지 간 간격
                            _buildBadge("리뷰 ${store['reviewScore']}"),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.6), // 내부 여백
      decoration: BoxDecoration(
        color: Colors.white, // 배경색 (투명한 흰색)
        border: Border.all(
          color: Color(0xFFE7E6F2),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0), // 둥근 테두리
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF5D5A88),
        ),
      ),
    );
  }
}
