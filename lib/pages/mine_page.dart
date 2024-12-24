import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Toast/flutter_toast.dart';
import 'mine/settings.dart';
import '../common/sharedppreferences.dart/sharedPreferences.dart';

class minePage extends StatefulWidget {
  const minePage({super.key});

  @override
  State<minePage> createState() => _MinePageState();
}

class _MinePageState extends State<minePage> {
  int _counter = 0;
  bool _hasCheckedInToday = false;
  String? username = '用户9527';

  final ImagePicker _picker = ImagePicker();
  XFile? _image; // 用于存储选择的图片文件

  // 从相册选择图片
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
        _saveImage(image.path);
      });
    }
  }

  // 使用相机拍照
  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
        _saveImage(image.path);
      });
    }
  }

  // 保存图片路径到SharedPreferences
  Future<void> _saveImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('image_path', imagePath);
  }

  // 从SharedPreferences加载图片路径
  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('image_path');
    if (imagePath != null) {
      setState(() {
        _image = XFile(imagePath); // 加载图片
      });
    }
  }

  // 签到

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadUsername();
    });
    _loadCheckInStatus();
    _loadImage();
    _checkInStatus();
  }

  // 加载用户名
  Future<void> _loadUsername() async {
    final loadedUsername = await getString('username'); // 获取用户名
    setState(() {
      username = loadedUsername; // 更新 username
    });
  }

  // 保存计数器路径到SharedPreferences
  Future<void> _checkIn() async {
    String today = DateTime.now().toIso8601String().substring(0, 10);
    final prefs = await SharedPreferences.getInstance();
    if (_hasCheckedInToday) {
      return;
    } else {
      await prefs.setString(today, 'chekcin');
      setState(() {
        _hasCheckedInToday = true;
        _loadCheckInStatus();
        showSuccessToast(msg: '签到成功');
      });
    }
  }

  // 加载签到天数
  Future<void> _loadCheckInStatus() async {
    // String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    // 定义正则表达式，匹配 "yyyy-MM-dd" 格式的日期
    int count = 0;
    RegExp regExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    for (String date in keys) {
      if (regExp.hasMatch(date)) {
        count++;
      }
    }
    setState(() {
      _counter = count;
    });
  }

  // 查询是否签到
  Future<void> _checkInStatus() async {
    String today = DateTime.now().toIso8601String().substring(0, 10);
    final prefs = await SharedPreferences.getInstance();
    final isCheckIn = prefs.getString(today);
    if (isCheckIn != null) {
      setState(() {
        _hasCheckedInToday = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 签到
    final checkIn = Row(
      children: [
        GestureDetector(
          onTap: () async {
            await settings(context: context);
            _loadUsername();
          },
          child: Container(
            padding: const EdgeInsets.only(top: 40, left: 15),
            child: const Text(
              '设置',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: _hasCheckedInToday ? null : _checkIn,
          child: Container(
            padding: const EdgeInsets.all(5), // 给Container添加内边距
            margin:
                const EdgeInsets.only(top: 40, right: 15), // 给Container添加外边距
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                Text(
                  _hasCheckedInToday ? '已签到' : '签到',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    //头像
    const avatarTextStyle = TextStyle(
      fontSize: 17,
    );
    final mineAvatar = Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pickImageFromCamera();
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                                child: Text(
                              '拍摄照片',
                              style: avatarTextStyle,
                            ))),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _pickImageFromGallery();
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                                child: Text(
                              '上传头像',
                              style: avatarTextStyle,
                            ))),
                      ),
                    ],
                  ),
                );
              });
        },
        child: CircleAvatar(
          radius: 40,
          backgroundImage: _image == null
              ? const AssetImage('assets/images/avatar.png')
              : FileImage(File(_image!.path)),
        ),
      ),
    );

    final mineIntro = Column(children: [
      Text('已连续签到$_counter天'),
      const SizedBox(
        height: 10,
      ),
      Text(username != null ? '$username' : '用户9527'),
    ]);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Colors.white
            ], // 渐变颜色
            begin: Alignment.topLeft, // 渐变开始位置
            end: Alignment.bottomRight, // 渐变结束位置
          ),
        ),
        child: Column(
          children: [
            checkIn,
            mineAvatar,
            mineIntro,
          ],
        ),
      ),
    );
  }
}
