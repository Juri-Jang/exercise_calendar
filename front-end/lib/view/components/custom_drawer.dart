import 'package:flutter/material.dart';

Widget CustomDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("John Doe"),
          accountEmail: Text("johndoe@example.com"),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              "J",
              style: TextStyle(fontSize: 40.0),
            ),
          ),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 88, 95, 227),
          ),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            // Settings 메뉴 클릭 시 처리할 동작
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            // Logout 메뉴 클릭 시 처리할 동작
          },
        ),
      ],
    ),
  );
}
