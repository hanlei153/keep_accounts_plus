import 'package:flutter/material.dart';

import 'home_page.dart';
import 'write_down.dart';
import 'mine_page.dart';

class MainFramePage extends StatefulWidget {
  MainFramePage({super.key});

  @override
  State<MainFramePage> createState() => _MainFramePageState();
}

class _MainFramePageState extends State<MainFramePage> {
  int _selectedIndex = 0;
  // 当前选中的底部导航项
  final List<Widget> _pages = [HomePage(), WriteDownPage(), minePage()];

  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = 24;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTapItem,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icon/bottomNavigationBar/home.png',
              width: imageSize,
              fit: BoxFit.contain,
            ),
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icon/bottomNavigationBar/add.png',
              width: imageSize,
              fit: BoxFit.contain,
            ),
            label: "记一笔",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icon/bottomNavigationBar/mine.png',
              width: imageSize,
              fit: BoxFit.contain,
            ),
            label: "我的",
          ),
        ],
      ),
    );
  }
}
