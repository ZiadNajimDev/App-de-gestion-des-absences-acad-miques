// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:attendance_app/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Added for logout

class StudentDrawer extends StatelessWidget {
  final String studentName;

  const StudentDrawer({super.key, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.orangeAccent),
            child: Text(
              studentName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // ✅ Dashboard Navigation
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Tableau de bord"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/student');
            },
          ),

          // ✅ Logout Navigation with Session Clearing
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Déconnexion"),
            onTap: () async {
              // Clear faculty session
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              Navigator.pop(context); // Close the drawer

              // Clear all routes and push login page
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Déconnecté")),
              );
            },
          ),
        ],
      ),
    );
  }
}
