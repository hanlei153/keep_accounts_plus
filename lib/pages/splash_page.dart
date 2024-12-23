import 'package:flutter/material.dart';

import 'main_frame_page.dart';

class SplashPage extends StatefulWidget {
  // const MyHomePage({super.key});

  @override
  State<SplashPage> createState() => _SplashPagePageState();
}

class _SplashPagePageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              MainFramePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.linear,
              ),
            );

            // 设置更慢的淡入效果
            return FadeTransition(opacity: opacityAnimation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '记账Plus',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
