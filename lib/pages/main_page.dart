import 'package:flutter/material.dart';
import 'package:hello_flutter/theme/colors.dart';
import 'package:provider/provider.dart';

import '../components/menu_card.dart';
import '../widgets/bottom_navigation.dart';
import '../viewModels/store_detail_view_model.dart';
import 'dummy_store.dart';
import 'main_map_page.dart';
import 'store_detail_page.dart';
import 'filter.dart';
import 'search.dart';

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
                  readOnly: true,
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
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ),
                    );

                    if (result != null) {
                      print("필터 결과: $result");
                      // TODO: 선택된 필터값을 사용하여 매장 리스트 필터링
                    }
                  },
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
              child: GestureDetector(
                onTap: () {
                  // Provider.of<StoreDetailViewModel>(context, listen: false).setStore(store);
                  Provider.of<StoreDetailViewModel>(context, listen: false).setStore({
                    "place": {
                      "placeId": "a91728b8-f42d-11ef-b57a-0242ac110002",
                      "placeName": "레드제플린",
                      "phoneNumber": "01042877671",
                      "email": null,
                      "zipcode": "08778 ",
                      "address": "서울특별시 관악구 신림동 1641-50",
                      "addressDetail": "1층",
                      "latitude": 37.4808476,
                      "longitude": 126.93036499999998,
                      "reservable": true,
                      "takeout": false,
                      "placeSummary": {
                        "placeId": "a91728b8-f42d-11ef-b57a-0242ac110002",
                        "visitAvg": 0,
                        "visitCount": 0,
                        "reviewTotalAvg": 4.8,
                        "reviewTasteAvg": 0,
                        "reviewServiceAvg": 0,
                        "reviewAtmosphereAvg": 0,
                        "reviewCleanlinessAvg": 0,
                        "reviewValueAvg": 0,
                        "reviewTotalCount": 5,
                        "reviewTasteCount": 0,
                        "reviewServiceCount": 0,
                        "reviewAtmosphereCount": 0,
                        "reviewCleanlinessCount": 0,
                        "reviewValueCount": 0,
                        "benefitItemTitles": [
                          "라면",
                          "쥬스",
                          "콜라",
                          "환타",
                          "사이다",
                          "하이볼 한잔",
                          "계란말이",
                          "미니피자",
                          "맥주 1병",
                          "소주 1병",
                          "청하 1병",
                          "10% 할인",
                          "3,000원 할인",
                          "생맥주 500cc"
                        ],
                        "placeTypeTitles": [
                          "바 ∙ 술집"
                        ]
                      }
                    },
                    "placeId": "a91728b8-f42d-11ef-b57a-0242ac110002",
                    "placeName": "레드제플린",
                    "placeTypeTitles": [
                        "바 ∙ 술집"
                    ],
                    "visitRate": 0.0,
                    "visitCount": 0,
                    "reviewRate": 4.8,
                    "reviewCount": 5,
                    "phoneNumber": "01042877671",
                    "email": null,
                    "address": "서울특별시 관악구 신림동 1641-50",
                    "addressDetail": "",
                    "zipcode": "08778 ",
                    "latitude": 37.4808476,
                    "longitude": 126.93036499999998,
                    "reservable": true,
                    "takeout": false,
                    "createdAt": "2025-02-26T10:37:21.976812Z",
                    "placeMainItems": [
                        {
                            "placeMainItemId": null,
                            "placeItemId": "1395e226-dee2-4169-8d3b-6cc0514d16f3",
                            "itemName": "배꼽시계",
                            "itemPrice": 10000,
                            "itemImageUrl": "https://placehold.co/400x400",
                            "itemDescription": "배꼽시계 설명",
                            "itemDiscountPrice": 10000,
                            "itemDiscountRate": 10,
                            "sort": null,
                            "createdAt": null
                        }
                    ],
                    "placeHours": [
                        {
                            "dayOfWeek": 0,
                            "openTime": "19:00",
                            "closeTime": "03:00",
                            "breakStart": null,
                            "breakEnd": null
                        },
                        {
                            "dayOfWeek": 1,
                            "openTime": "19:00",
                            "closeTime": "03:00",
                            "breakStart": null,
                            "breakEnd": null
                        },
                        {
                            "dayOfWeek": 2,
                            "openTime": "19:00",
                            "closeTime": "03:00",
                            "breakStart": null,
                            "breakEnd": null
                        },
                        {
                            "dayOfWeek": 3,
                            "openTime": "19:00",
                            "closeTime": "03:00",
                            "breakStart": null,
                            "breakEnd": null
                        },
                        {
                            "dayOfWeek": 4,
                            "openTime": "19:00",
                            "closeTime": "03:00",
                            "breakStart": null,
                            "breakEnd": null
                        },
                        {
                            "dayOfWeek": 5,
                            "openTime": "19:00",
                            "closeTime": "03:00",
                            "breakStart": null,
                            "breakEnd": null
                        },
                        {
                            "dayOfWeek": 6,
                            "openTime": "19:00",
                            "closeTime": "03:00",
                            "breakStart": null,
                            "breakEnd": null
                        }
                    ],
                    "placeBenefits": [
                        {
                            "placeBenefitId": "15bdcd5e-f812-11ef-b5c9-6b5ce1a7dcc3",
                            "benefitCategoryTitle": "기본혜택",
                            "hasCondition": true,
                            "conditionValue": "15000",
                            "benefitTitle": "5,000원 혜택",
                            "placeBenefitItemGroups": [
                                {
                                    "id": "533f0b4e-f28f-11ef-b12c-1957147f23d8",
                                    "title": "주류",
                                    "data": {
                                        "ageLimit": true
                                    },
                                    "items": [
                                        {
                                            "id": "3fbad394-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "맥주 1병",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fbc2f78-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "생맥주 500cc",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fb979ae-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "소주 1병",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fbf31fa-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "청하 1병",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fbdb26c-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "하이볼 한잔",
                                            "benefitPrice": 5000
                                        }
                                    ]
                                },
                                {
                                    "id": "533f0b9e-f28f-11ef-b12c-1957147f23d8",
                                    "title": "금액할인",
                                    "data": {
                                        "ageLimit": false
                                    },
                                    "items": [
                                        {
                                            "id": "3fc23710-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "10% 할인",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fc0dd52-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "3,000원 할인",
                                            "benefitPrice": 5000
                                        }
                                    ]
                                },
                                {
                                    "id": "533f0be4-f28f-11ef-b12c-1957147f23d8",
                                    "title": "음료",
                                    "data": {
                                        "ageLimit": false
                                    },
                                    "items": [
                                        {
                                            "id": "3fc66ba0-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "사이다",
                                            "benefitPrice": 3000
                                        },
                                        {
                                            "id": "3fc7eade-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "쥬스",
                                            "benefitPrice": 3000
                                        },
                                        {
                                            "id": "3fc3940c-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "콜라",
                                            "benefitPrice": 3000
                                        },
                                        {
                                            "id": "3fc4fa7c-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "환타",
                                            "benefitPrice": 3000
                                        }
                                    ]
                                },
                                {
                                    "id": "533f0c3e-f28f-11ef-b12c-1957147f23d8",
                                    "title": "특별메뉴",
                                    "data": {
                                        "ageLimit": false
                                    },
                                    "items": [
                                        {
                                            "id": "3fca932e-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "계란말이",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fcbda2c-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "라면",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fc9460e-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "미니피자",
                                            "benefitPrice": 5000
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "placeBenefitId": "15bf2834-f812-11ef-b5c9-6b5ce1a7dcc3",
                            "benefitCategoryTitle": "기본혜택",
                            "hasCondition": true,
                            "conditionValue": "20000",
                            "benefitTitle": "6,000원 혜택",
                            "placeBenefitItemGroups": [
                                {
                                    "id": "533f0b4e-f28f-11ef-b12c-1957147f23d8",
                                    "title": "주류",
                                    "data": {
                                        "ageLimit": true
                                    },
                                    "items": [
                                        {
                                            "id": "3fce8b28-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "맥주 1병",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fcfe658-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "생맥주 500cc",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fcd31c4-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "소주 1병",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fd2c260-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "청하 1병",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fd168ac-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "하이볼 한잔",
                                            "benefitPrice": 5000
                                        }
                                    ]
                                },
                                {
                                    "id": "533f0b9e-f28f-11ef-b12c-1957147f23d8",
                                    "title": "금액할인",
                                    "data": {
                                        "ageLimit": false
                                    },
                                    "items": [
                                        {
                                            "id": "3fd5a796-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "10% 할인",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fd44414-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "3,000원 할인",
                                            "benefitPrice": 5000
                                        }
                                    ]
                                },
                                {
                                    "id": "533f0be4-f28f-11ef-b12c-1957147f23d8",
                                    "title": "음료",
                                    "data": {
                                        "ageLimit": false
                                    },
                                    "items": [
                                        {
                                            "id": "3fda84a0-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "사이다",
                                            "benefitPrice": 3000
                                        },
                                        {
                                            "id": "3fdbfcd6-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "쥬스",
                                            "benefitPrice": 3000
                                        },
                                        {
                                            "id": "3fd70c58-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "콜라",
                                            "benefitPrice": 3000
                                        },
                                        {
                                            "id": "3fd86562-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "환타",
                                            "benefitPrice": 3000
                                        }
                                    ]
                                },
                                {
                                    "id": "533f0c3e-f28f-11ef-b12c-1957147f23d8",
                                    "title": "특별메뉴",
                                    "data": {
                                        "ageLimit": false
                                    },
                                    "items": [
                                        {
                                            "id": "3fdec4fc-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "계란말이",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fe02072-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "라면",
                                            "benefitPrice": 5000
                                        },
                                        {
                                            "id": "3fdd681e-f813-11ef-9cb1-613ce4a7c27f",
                                            "title": "미니피자",
                                            "benefitPrice": 5000
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "placeItems": null,
                    "placeReviews": {
                        "pageNumber": 0,
                        "pageSize": 5,
                        "totalElements": 5,
                        "totalPages": 1,
                        "last": true,
                        "first": true,
                        "content": [
                            {
                                "authorName": "Chang-Yong Park,",
                                "score": 4,
                                "description": "LP음악과 신청곡으로 맥주를 마시는 바\n그날 오는 손님에 따라 음악 장르가 다르네요.",
                                "createdAt": "2024-07-29T04:04:30.734504Z",
                                "updatedAt": "2025-03-14T08:18:08.891675Z",
                                "user": null,
                                "placeItem": {
                                    "placeItemId": "d5d1ed4e-00ac-11f0-ae9a-bd6d6a8644a8",
                                    "itemName": "육사시미-3",
                                    "price": 30000,
                                    "reviewRate": 0.0,
                                    "reviewCount": 0
                                }
                            },
                            {
                                "authorName": "Sabbath",
                                "score": 5,
                                "description": "칵테일과 맥주, 와인, 안주가 있습니다. 칵테일의 경우 데킬라 선라이즈 등 간단한 믹스 칵테일 위주입니다. 신청곡을 최소 한 곡 이상 틀어주시는데, 사람이 많을 때는 밀리거나 많은 곡을 못 들을 때도 있지만 사람이 없을 때는 거의 쓰는 대로 틀어주십니다. 음악 소리가 큰 편이라 대화보다는 서로 음악 추천해주거나, 혼자 오시는 것을 추천합니다. 아주 아늑하고 사장님도 좋으셔서 매달 한 번 이상은 가게 되는, 마음의 고향입니다. 락이나 메탈을 좋아하신다면 좋은 음악을 많이 알아갈 수 있고, 가끔 바테이블에서 옆 손님들과 이야기를 나누는 것도 재미있습니다. 그리고 가끔 라이브도 합니다. 오래 유지되었으면 하는 가게입니다.",
                                "createdAt": "2024-03-12T14:40:39.234534Z",
                                "updatedAt": "2025-03-14T08:18:08.891675Z",
                                "user": null,
                                "placeItem": {
                                    "placeItemId": "d5d1ed4e-00ac-11f0-ae9a-bd6d6a8644a8",
                                    "itemName": "육사시미-3",
                                    "price": 30000,
                                    "reviewRate": 0.0,
                                    "reviewCount": 0
                                }
                            },
                            {
                                "authorName": "김로아",
                                "score": 5,
                                "description": "낭만있어요\n음악이 너무 좋아서\n친구들과 2차로 왔었는데\n캬~~완전좋았음\n자주오고싶은데 ~~내가 너무 멀리살아요 ㅜ",
                                "createdAt": "2023-01-28T16:40:04.593298Z",
                                "updatedAt": "2025-03-14T08:18:08.891675Z",
                                "user": null,
                                "placeItem": {
                                    "placeItemId": "d5d62080-00ac-11f0-ae9a-bd6d6a8644a8",
                                    "itemName": "육사시미-4",
                                    "price": 30000,
                                    "reviewRate": 0.0,
                                    "reviewCount": 0
                                }
                            },
                            {
                                "authorName": "janet자넷",
                                "score": 5,
                                "description": "신청곡 틀어줘요 아이돌은 안된다고 하더라구요 ^^;; 버드와이저 좋아해서 이차로 좋아요 오래전부터 있던 가게인데 아직도 여긴 장사를 하네요 ^^ 레트로 감성 가지기 좋습니다",
                                "createdAt": "2020-10-28T02:52:37.190803Z",
                                "updatedAt": "2025-03-14T08:18:08.891675Z",
                                "user": null,
                                "placeItem": {
                                    "placeItemId": "d5d1ed4e-00ac-11f0-ae9a-bd6d6a8644a8",
                                    "itemName": "육사시미-3",
                                    "price": 30000,
                                    "reviewRate": 0.0,
                                    "reviewCount": 0
                                }
                            },
                            {
                                "authorName": "샤니콩",
                                "score": 5,
                                "description": "신림 LP바&뮤직펍\n분위기 너무좋아요\n노래 신청도 가능하구요\n사운드 빵빵하게 좋은노래 듣고싶은노래 많이 듣고 왔어요!!!\n사장님 친절하시고 서비스 짱짱👍👍👍\n단골됬어요♡♡♡",
                                "createdAt": "2018-07-11T14:06:14.524Z",
                                "updatedAt": "2025-03-14T08:18:08.891675Z",
                                "user": null,
                                "placeItem": {
                                    "placeItemId": "d5c8f14e-00ac-11f0-ae9a-bd6d6a8644a8",
                                    "itemName": "육사시미-1",
                                    "price": 30000,
                                    "reviewRate": 0.0,
                                    "reviewCount": 0
                                }
                            }
                        ]
                    },
                    "placeRegularHolidays": []
                });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoreDetailScreen(),
                    ),
                  );
                },
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
