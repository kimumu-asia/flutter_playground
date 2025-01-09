import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final ValueChanged<int> onTap; // 탭 선택 시 호출되는 콜백

  const BottomNavigation({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0; // 현재 선택된 탭의 인덱스

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // 현재 선택된 탭 인덱스
      onTap: (index) {
        setState(() {
          _currentIndex = index; // 내부 상태 업데이트
        });
        widget.onTap(index); // 부모로 선택된 인덱스를 전달
      },
      type: BottomNavigationBarType.fixed, // 고정된 스타일
      selectedItemColor: Color(0xff1CAE81), // 선택된 아이템 색상
      unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
      backgroundColor: Colors.white, // 배경색
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '매장찾기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: '즐겨찾기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code),
          label: '구독인증',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: '알림',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '프로필',
        ),
      ],
    );
  }
}
