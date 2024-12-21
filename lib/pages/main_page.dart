import 'package:flutter/material.dart';

import 'dummy_store.dart';
import 'main_map_page.dart';

class MainPage extends StatelessWidget {
  static const String getStoresQuery = r'''
    query getStores($searchQueryDto: SearchQueryDtoInput) {
      stores(searchQueryDto: $searchQueryDto) {
        storeName
        reviewScore
        reviewCount
      }
    }
  ''';

  Map<String, dynamic> searchQueryDto = {
    'latitude': 37.4821,
    'longitude': 126.9304,
    'zoomLevel': 9,
  };

  @override
  Widget build(BuildContext context) {
    final List<dynamic> items = dummyStores['data']['stores'];

    print('Rendering ${items.length} items');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  }),
            ],
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(120.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        autocorrect: true,
                        decoration: InputDecoration(
                          labelText: '매장을 검색해 볼까요?',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          // searchQueryDto = value;
                        },
                      ),
                    ),
                    TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.store)),
                        Tab(icon: Icon(Icons.map_outlined)),
                      ],
                    ),
                  ],
                ))),
        body: Column(
          children: [
            // CircleAvatar ListView (탭 바 위)
            SizedBox(
              height: 120, // CircleAvatar 영역 높이
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(8.0),
                children: [
                  _buildCategoryItem('고기'),
                  _buildCategoryItem('회 & 일식'),
                  _buildCategoryItem('찜 & 탕 & 전골'),
                  _buildCategoryItem('한식'),
                  _buildCategoryItem('양식'),
                ],
              ),
            ),
            // TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      Expanded(
                          child: items.isEmpty
                              ? Center(
                                  child: Text(
                                    '매장을 찾을 수 없습니다.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                )
                              : SizedBox(
                                  height: 1600,
                                  child: GridView.builder(
                                    padding: EdgeInsets.all(4.0),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1, // 한 줄에 표시할 카드 개수
                                      childAspectRatio: 2.5, // 카드의 가로 세로 비율
                                      crossAxisSpacing: 10.0, // 카드 간격
                                      mainAxisSpacing: 10.0,
                                    ),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      final store = items[index];
                                      final benefitItems = store['benefitItems']
                                          as List<dynamic>;
                                      final firstBenefit =
                                          benefitItems.isNotEmpty
                                              ? benefitItems[0]
                                              : null;
                                      return Column(
                                        children: [
                                          Card(
                                            elevation: 0,
                                            clipBehavior: Clip.hardEdge,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8.0), // 모서리 둥글기
                                              side: BorderSide(
                                                color:
                                                    Color(0xFFE7E6F2), // 테두리 색상
                                                width: 1.0, // 테두리 두께
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // 왼쪽 이미지 섹션
                                                    Column(
                                                      children: [
                                                        Container(
                                                          height:
                                                              90, // 원하는 높이로 설정
                                                          width:
                                                              140, // 원하는 너비로 설정
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                'https://plus.unsplash.com/premium_photo-1679503585289-c02467981894?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cmVzdHJhdW50fGVufDB8fDB8fHww',
                                                              ),
                                                              fit: BoxFit
                                                                  .cover, // 이미지를 꽉 채우기
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // 중앙 정보 섹션
                                                    Expanded(
                                                      flex: 5,
                                                      child: Container(
                                                        color: Colors
                                                            .white, // 배경색 설정
                                                        padding: const EdgeInsets
                                                            .all(
                                                            10.0), // 내부 여백 추가
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            if (benefitItems
                                                                .isNotEmpty) ...[
                                                              ...benefitItems
                                                                  .map(
                                                                      (benefit) {
                                                                final title =
                                                                    benefit['title'] ??
                                                                        "혜택 없음";
                                                                return Column(
                                                                    children: [
                                                                      Text(
                                                                        '${benefit['benefitPrice']}원 혜택',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Color(0xFF5D5A88)),
                                                                      ),
                                                                      Text(
                                                                        title,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Color(0xFF5D5A88),
                                                                        ),
                                                                      ),
                                                                    ]);
                                                              }),
                                                            ] else
                                                              Text(
                                                                "혜택 없음",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xFF5D5A88),
                                                                ),
                                                              ),
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "리뷰 점수: ${store['reviewScore']}점",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  "방문자 수: ${store['reviewCount']}명",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Favorite 아이콘 고정
                                                Positioned(
                                                  top:
                                                      10, // Container의 상단에서의 거리
                                                  left:
                                                      10, // Container의 오른쪽에서의 거리
                                                  child: Icon(
                                                      Icons.favorite_border,
                                                      color: Color(0xFF5D5A88)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          12.0), // margin-left와 동일한 동작
                                                  child: Text(
                                                    store['storeName'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xFF5D5A88)),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    minimumSize: Size(80, 32),
                                                    backgroundColor:
                                                        Color(0xFF3A595D),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.0,
                                                            vertical: 0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '재방문율 3.2회',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors
                                                          .white, // 텍스트 색상 설정
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                SizedBox(width: 8), // 배지 간 간격
                                                _buildBadge(
                                                    "리뷰 ${store['reviewCount']}건"),
                                                SizedBox(width: 8), // 배지 간 간격
                                                _buildBadge(
                                                    "리뷰 ${store['reviewScore']}"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  // child: Query(
                                  //   options: QueryOptions(
                                  //     document: gql(getStoresQuery),
                                  //     variables: {
                                  //       'searchQueryDto': {
                                  //         'latitude': searchQueryDto['latitude'],
                                  //         'longitude': searchQueryDto['longitude'],
                                  //         'zoomLevel': searchQueryDto['zoomLevel'],
                                  //       },
                                  //     },
                                  //   ),
                                  //   builder: (QueryResult result,
                                  //       {VoidCallback? refetch, FetchMore? fetchMore}) {
                                  //     print('GraphQL Response: ${result.data}');
                                  //     if (result.isLoading) {
                                  //       return Center(child: CircularProgressIndicator());
                                  //     }
                                  // ),
                                )),
                    ],
                  ),
                  MainMap(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36, // 원형 아이콘 크기
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
        ],
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
