import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/splash_page.dart';
import 'theme.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // 提供 ThemeProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (themeProvider.loadThemeStatus != null) {
      themeProvider.loadThemeStatus();
    } else {
      themeProvider.toggleTheme(true); // 默认为系统主题
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeProvider.themeMode,
        home: SplashPage(),
      );
    });
  }
}
