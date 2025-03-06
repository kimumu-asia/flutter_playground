import 'package:flutter/material.dart';
import 'package:hello_flutter/theme/colors.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool isChickenSelected = false;
  bool isKoreanSelected = false;
  RangeValues priceRange = RangeValues(10000, 50000);
  double rating = 3.0;

  List<String> benefitTypes = ["주류", "할인", "음료", "특별메뉴"];
  List<bool> benefitSelected = [true, false, true, false];

  List<String> days = ["일", "월", "화", "수", "목", "금", "토"];
  List<bool> selectedDays = [false, false, true, false, true, false, false];
  List<String> openStatus = ["전체", "영업중", "영업종료"];
  List<bool> selectedOpenStatus = [false, false, true];

  int visitCount = 10;
  double revisitRate = 0.0;

  Map<String, int> ratingCriteria = {
    "맛": -1,
    "친절도": 5,
    "인테리어": 4,
    "위생": -1,
  };

  @override
  Widget build(BuildContext context) {
    return Material( // 🟢 Material 추가 (ListTile 오류 해결)
      child: Scaffold(
        backgroundColor: AppColors.backgroundOrange,
        appBar: AppBar(
          title: Text("필터", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.backgroundOrange,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterCard("혜택 종류", _buildBenefitFilter()),
              _buildFilterCard("재방문률 및 방문수", _buildRevisitAndVisitCount()),
              _buildFilterCard("혜택 가능 요일", _buildDayFilter()),
              _buildFilterCard("항목별 점수", _buildRatingCriteria()),
              _buildFilterCard("오픈 상태", _buildOpenStatusFilter()),
              SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: _buildActionButtons(),
      ),
    );
  }

  /// ✅ 필터 그룹을 감싸는 카드 UI
  Widget _buildFilterCard(String title, Widget child) {
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
  Widget _buildBenefitFilter() {
    return Wrap(
      spacing: 8,
      children: List.generate(benefitTypes.length, (index) {
        return ChoiceChip(
          showCheckmark: false,
          label: Text(benefitTypes[index]),
          selected: benefitSelected[index],
          selectedColor: Colors.white,
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(
              color: benefitSelected[index] ? Colors.green : Colors.grey,
              width: 1,
            ),
          ),
          labelStyle: TextStyle(color: benefitSelected[index] ? AppColors.primaryGreen : Colors.grey),
          onSelected: (selected) {
            setState(() {
              benefitSelected[index] = selected;
            });
          },
        );
      }),
    );
  }

  /// ✅ 재방문률 & 방문수
  Widget _buildRevisitAndVisitCount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("재방문률"),
            Row(
              children: [
                _buildAdjustButton(() {
                  setState(() {
                    revisitRate = revisitRate > 0 ? revisitRate - 5 : 0;
                  });
                }, Icons.remove),
                SizedBox(width: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 80, // ✅ 최소 너비 설정
                  ),
                  child: Text(revisitRate > 0 ? "$revisitRate%" : "상관없음", textAlign: TextAlign.center),
                ),
                SizedBox(width: 10),
                _buildAdjustButton(() {
                  setState(() {
                    revisitRate = revisitRate < 100 ? revisitRate + 5 : 100;
                  });
                }, Icons.add),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("방문수"),
            Row(
              children: [
                _buildAdjustButton(() {
                  setState(() {
                    visitCount = visitCount > 0 ? visitCount - 1 : 0;
                  });
                }, Icons.remove),
                SizedBox(width: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 80, // ✅ 최소 너비 설정
                  ),
                  child: Text("$visitCount 명 이상", textAlign: TextAlign.center),
                ),
                SizedBox(width: 10),
                _buildAdjustButton(() {
                  setState(() {
                    visitCount = visitCount + 1;
                  });
                }, Icons.add),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// ✅ 혜택 가능 요일
  Widget _buildDayFilter() {
    return Wrap(
      spacing: 8,
      children: List.generate(days.length, (index) {
        return ChoiceChip(
          showCheckmark: false,
          label: Text(days[index]),
          selected: selectedDays[index],
          selectedColor: Colors.white,
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(
              color: selectedDays[index] ? AppColors.primaryGreen : Colors.grey,
              width: 1,
            ),
          ),
          labelStyle: TextStyle(color: selectedDays[index] ? AppColors.primaryGreen : Colors.grey),
          onSelected: (selected) {
            setState(() {
              selectedDays[index] = selected;
            });
          },
        );
      }),
    );
  }

  // 운영 상태
  Widget _buildOpenStatusFilter() {
    return Wrap(
      spacing: 8,
      children: List.generate(openStatus.length, (index) {
        return ChoiceChip(
          showCheckmark: false,
          label: Text(openStatus[index]),
          selected: selectedOpenStatus[index],
          selectedColor: Colors.white,
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(
              color: selectedOpenStatus[index] ? AppColors.primaryGreen : Colors.grey,
              width: 1,
            ),
          ),
          labelStyle: TextStyle(color: selectedOpenStatus[index] ? AppColors.primaryGreen : Colors.grey),
          onSelected: (selected) {
            setState(() {
              selectedOpenStatus[index] = selected;
            });
          },
        );
      }),
    );
  }

  /// ✅ 항목별 점수 (맛, 친절도 등)
  Widget _buildRatingCriteria() {
    return Column(
      children: ratingCriteria.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.key),
              Row(
                children: [
                  _buildAdjustButton(() {
                    setState(() {
                      ratingCriteria[entry.key] = ratingCriteria[entry.key]! > 0 ? ratingCriteria[entry.key]! - 1 : -1;
                    });
                  }, Icons.remove),
                  SizedBox(width: 10),
                  ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 80, // ✅ 최소 너비 설정
                    ),
                    child: Text(ratingCriteria[entry.key]! > 0 ? "${ratingCriteria[entry.key]}점 이상" : "상관없음", textAlign: TextAlign.center),
                  ),
                  SizedBox(width: 10),
                  _buildAdjustButton(() {
                    setState(() {
                      ratingCriteria[entry.key] = ratingCriteria[entry.key]! < 5 ? ratingCriteria[entry.key]! + 1 : 5;
                    });
                  }, Icons.add),
                ],
              ),
            ],
          ),
        );
      }).toList(),
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
                // setState(() {
                //   isChickenSelected = false;
                //   isKoreanSelected = false;
                //   priceRange = RangeValues(10000, 50000);
                //   rating = 3.0;
                // });
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
