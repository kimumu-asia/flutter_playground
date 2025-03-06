import 'package:flutter/material.dart';
import 'package:hello_flutter/theme/colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<String> areas = ["신림", "사당", "구로", "역삼", "여의도", "송파", "성수", "연남", "이태원"];
  List<bool> selectedAreas = [true, false, true, false, false, false, false, false, false];

  List<String> keywords = ["아시안", "피자", "성수핫플", "양꼬치", "사케바", "파인다이닝", "회식"];
  List<bool> selectedKeywords = [false, false, true, false, true, false, false];

 /// 검색어 입력 TextField 컨트롤러
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material( // 🟢 Material 추가 (ListTile 오류 해결)
      child: Scaffold(
        backgroundColor: AppColors.backgroundOrange,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundOrange,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard("어느 지역으로 가볼까요?", _buildAreas()),
              _buildCard("메뉴 또는 매장명을 알려주세요!", _buildSearchBar()),
              _buildCard("혜택 가능 요일", _buildMarkedKeywords()),
              SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: _buildActionButtons(),
      ),
    );
  }

  /// ✅ 필터 그룹을 감싸는 카드 UI
  Widget _buildCard(String title, Widget child) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  /// ✅ 혜택 종류 (주류, 할인 등 선택)
  Widget _buildAreas() {
    return Wrap(
      spacing: 8,
      children: List.generate(areas.length, (index) {
        return ChoiceChip(
          showCheckmark: false,
          label: Text(areas[index]),
          selected: selectedAreas[index],
          selectedColor: Colors.white,
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(
              color: selectedAreas[index] ? Colors.green : Colors.grey,
              width: 1,
            ),
          ),
          labelStyle: TextStyle(color: selectedAreas[index] ? AppColors.primaryGreen : Colors.grey),
          onSelected: (selected) {
            setState(() {
              selectedAreas[index] = selected;
            });
          },
        );
      }),
    );
  }

  /// ✅ 검색 바 (메뉴/매장명)
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        hintText: "메뉴 혹은 매장명 입력",
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryGreen),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// ✅ 최근 검색 키워드
  Widget _buildMarkedKeywords() {
    return Wrap(
      spacing: 8,
      children: List.generate(keywords.length, (index) {
        return ChoiceChip(
          showCheckmark: false,
          label: Text(keywords[index]),
          selected: selectedKeywords[index],
          selectedColor: Colors.white,
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(
              color: selectedKeywords[index] ? Colors.green : Colors.grey,
              width: 1,
            ),
          ),
          labelStyle: TextStyle(color: selectedKeywords[index] ? AppColors.primaryGreen : Colors.grey),
          onSelected: (selected) {
            setState(() {
              selectedKeywords[index] = selected;
            });
          },
        );
      }),
    );
  }

  // NOTE: 증감 버튼
  Widget _buildAdjustButton(VoidCallback onPressed, IconData icon) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
        child: Icon(icon, size: 18, color: Colors.black),
      ),
    );
  }

  // 필터 적용/취소 버튼
  Widget _buildActionButtons() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 64, vertical: 14),
                shape: StadiumBorder(),
                backgroundColor: AppColors.secondaryPrimaryMainOrange,
                elevation: 0,
              ),
              onPressed: () => {
                Navigator.pop(context)
              },
              child: Text("초기화", style: TextStyle(color: AppColors.accentPrimaryMainOrange, fontSize: 15, fontWeight: FontWeight.w900)),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 64, vertical: 14),
                shape: StadiumBorder(),
                backgroundColor: AppColors.primaryGreen,
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("매장", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
            ),
          ],
      ),
    );
  }
}
