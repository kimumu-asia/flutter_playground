import 'package:flutter/material.dart';
import 'package:hello_flutter/theme/colors.dart';

class Benefit {
  final String id;
  final String categoryTitle;
  final bool hasCondition;
  final String conditionValue;
  final String title;
  final List<BenefitItemGroup> itemGroups;

  Benefit({
    required this.id,
    required this.categoryTitle,
    required this.hasCondition,
    required this.conditionValue,
    required this.title,
    required this.itemGroups,
  });

  // JSON 데이터를 Benefit 객체로 변환하는 함수
  factory Benefit.fromJson(Map<String, dynamic> json) {
    return Benefit(
      id: json['placeBenefitId'],
      categoryTitle: json['benefitCategoryTitle'],
      hasCondition: json['hasCondition'],
      conditionValue: json['conditionValue'],
      title: json['benefitTitle'],
      itemGroups: (json['placeBenefitItemGroups'] as List<dynamic>)
          .map((group) => BenefitItemGroup.fromJson(group))
          .toList(),
    );
  }
}

class BenefitItemGroup {
  final String id;
  final String title;
  final bool ageLimit;
  final List<BenefitItem> items;

  BenefitItemGroup({
    required this.id,
    required this.title,
    required this.ageLimit,
    required this.items,
  });

  // JSON 데이터를 BenefitItemGroup 객체로 변환하는 함수
  factory BenefitItemGroup.fromJson(Map<String, dynamic> json) {
    return BenefitItemGroup(
      id: json['id'],
      title: json['title'],
      ageLimit: json['data']['ageLimit'],
      items: (json['items'] as List<dynamic>)
          .map((item) => BenefitItem.fromJson(item))
          .toList(),
    );
  }
}

class BenefitItem {
  final String id;
  final String title;
  final int benefitPrice;

  BenefitItem({
    required this.id,
    required this.title,
    required this.benefitPrice,
  });

  // JSON 데이터를 BenefitItem 객체로 변환하는 함수
  factory BenefitItem.fromJson(Map<String, dynamic> json) {
    return BenefitItem(
      id: json['id'],
      title: json['title'],
      benefitPrice: json['benefitPrice'],
    );
  }
}

class BenefitCard extends StatelessWidget {
  final Benefit benefit;

  BenefitCard({required this.benefit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // 가로 스크롤을 위한 너비
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 혜택 제목과 내용을 Expanded로 감싸서 남은 공간을 차지하도록 함
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 혜택 제목
                Text(
                  benefit.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "아래 혜택 중 한 가지 선택 가능!",
                  style: TextStyle(color: AppColors.textBodyGray),
                ),
                SizedBox(height: 12),

                // 혜택 그룹별 목록
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: benefit.itemGroups.map((group) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.title,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: group.items.map((item) {
                              return Chip(
                                label: Text(item.title),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // 최소 주문 금액 (바닥에 고정)
          Column(
            children: [
              Divider(),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("최소 주문 금액", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(
                    "${benefit.conditionValue}원",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
