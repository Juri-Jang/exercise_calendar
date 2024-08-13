import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions; // AppBar 오른쪽에 들어갈 위젯들
  final bool centerTitle;
  final PreferredSizeWidget? bottom; // AppBar 하단에 들어갈 위젯 (예: TabBar)

  CustomAppBar({
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(color: Colors.white)),
      centerTitle: centerTitle,
      backgroundColor: Color.fromARGB(255, 88, 95, 227), // 원하는 색상으로 변경 가능
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom == null
      ? kToolbarHeight
      : kToolbarHeight + bottom!.preferredSize.height);
}
