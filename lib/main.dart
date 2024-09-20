import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyFoodReceipe(),
    );
  }
}

class FoodItem {
  String title;
  String imageUrl;

  FoodItem({required this.title, required this.imageUrl});
}

class MyFoodReceipe extends StatelessWidget {
  List<FoodItem> items = [
    FoodItem(
      title: '수제버거',
      imageUrl: 'assets/images/burger.png',
    ),
    FoodItem(
      title: '건강식',
      imageUrl: 'assets/images/health.jpg',
    ),
    FoodItem(
      title: '햄버거',
      imageUrl: 'assets/images/originalBurger.jpg',
    ),
    FoodItem(
      title: '한식',
      imageUrl: 'assets/images/koreanFood.jpg',
    ),
    FoodItem(
      title: '디저트',
      imageUrl: 'assets/images/dessert.jpg',
    ),
    FoodItem(
      title: '피자',
      imageUrl: 'assets/images/pizza.jpg',
    ),
  ];

  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Recipe'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // 눌렀을때 핸들러
              })
        ],
      ),
      body: Column(
        children: [
          // * 검색창
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  autocorrect: true,
                  decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search)))),
          // * 그리드뷰
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(7.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 그리드의 열 개수
                crossAxisSpacing: 2.0, // 열 간격
                mainAxisSpacing: 2.0, // 행 간격
              ),
              itemCount:
                  items.where((item) => item.title.contains(query)).length,
              itemBuilder: (context, index) {
                var filteredItems =
                    items.where((item) => item.title.contains(query)).toList();
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0), // 둥근 모서리 반경 설정
                  ),
                  elevation: 2,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage(filteredItems[index].imageUrl), // 이미지 경로
                        fit: BoxFit.cover, // background-size: cover처럼 적용
                      ),
                    ),
                    child: Center(
                      child: Text(
                        filteredItems[index].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
