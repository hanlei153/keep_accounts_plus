import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 导入 provider
import '../../theme_provider.dart'; // 导入 ThemeProvider
import '../../common/sharedppreferences.dart/sharedPreferences.dart';
import 'edit_settings.dart';

Future<void> settings({required BuildContext context}) async {
  const TextStyle textStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  final username = await getString('username');

  await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('用户名', style: textStyle),
                    GestureDetector(
                        onTap: () {
                          String displayName;
                          if (username != null) {
                            // 如果 username 不为 null，执行某些操作
                            displayName = username; // 使用 username 的值
                          } else {
                            // 如果 username 为 null，使用默认值
                            displayName = '用户9527'; // 默认值
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditSettings(
                                        title: '用户名',
                                        contentText: displayName,
                                      )));
                        },
                        child: Text(
                            username != null ? '$username >' : '用户9527 >',
                            style: textStyle))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('主题跟随系统', style: textStyle),
                    Switch(
                      value: Provider.of<ThemeProvider>(context).isSystemTheme,
                      onChanged: (bool value) {
                        // 切换主题模式
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
