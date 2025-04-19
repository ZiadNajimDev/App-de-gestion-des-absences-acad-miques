import 'package:flutter/material.dart';
import 'package:attendance_app/pages/admin/admin_home.dart';
import 'package:attendance_app/pages/login_page.dart';
import 'package:attendance_app/pages/admin/add_faculty.dart';
import 'package:attendance_app/pages/admin/promote_students.dart'; // Import the new screen
import 'package:attendance_app/pages/admin/add_student.dart';
import 'package:attendance_app/pages/admin/create_class.dart';

class CustomDrawer extends StatelessWidget {
  final String adminName; // Accept admin name as a parameter

  const CustomDrawer({super.key, required this.adminName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_circle, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  adminName, // Display the admin name dynamically
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Accueil"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminHomePage(adminName: adminName),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("AJOUTER UN ENSEIGNANT"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFaculty(adminName: adminName),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("AJOUTER UN ÉTUDIANT"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStudent(adminName: adminName),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.upgrade),
            title: Text("Promouvoir les étudiants"), // New menu item
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PromoteStudentsScreen(
                        adminName: adminName,
                      ), // Navigate to the new screen
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.add),
            title: Text("CRÉER UNE CLASSE"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          AssignSubjectFacultyPage(adminName: adminName),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Déconnexion"),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Logged Out")));
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
