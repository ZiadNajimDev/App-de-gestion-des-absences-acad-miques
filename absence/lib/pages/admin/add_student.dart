import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:attendance_app/components/custom_drawer.dart';
import 'package:attendance_app/pages/admin/upload_students.dart';

class AddStudent extends StatefulWidget {
  final String adminName;

  const AddStudent({super.key, required this.adminName});

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  // Updated regex to specifically validate Gmail addresses
  final _gmailRegex = RegExp(
    r'^[a-zA-Z0-9](?:[a-zA-Z0-9.]{0,62}[a-zA-Z0-9])?@gmail\.com$',
    caseSensitive: false,
  );
  final _passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? selectedDepId;
  String? selectedSemester;
  List<Map<String, String>> departments = [];
  final List<String> semesters = [
    "S1",
    "S2",
    "S3",
    "S4",
    "S5",
    "S6",
    "S7",
    "S8",
  ];

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    String url = "http://192.168.11.107/localconnect/get_departments.php";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          departments =
              data
                  .map(
                    (item) => {
                      "depid": item["depid"].toString(),
                      "name": item["name"].toString(),
                    },
                  )
                  .toList();
          if (departments.isNotEmpty) {
            selectedDepId = departments[0]["depid"];
          }
        });
      }
    } catch (e) {
      print("Error fetching departments: $e");
    }
  }

  Future<void> addStudent() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDepId == null || selectedSemester == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez sélectionner à la fois le département et le semestre"),
        ),
      );
      return;
    }

    // Verify Gmail address before proceeding
    if (!_gmailRegex.hasMatch(emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer une adresse Gmail valide")),
      );
      return;
    }

    String apiUrl = "http://192.168.11.107/localconnect/add_student.php";
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "name": nameController.text.trim(),
        "username": usernameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "department_id": selectedDepId!,
        "semester": selectedSemester!,
      },
    );

    try {
      var data = jsonDecode(response.body);
      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Étudiant ajouté avec succès")),
        );
        nameController.clear();
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed: ${data['message']}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error parsing response")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Ajouter un étudiant",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[200],
      ),
      drawer: CustomDrawer(adminName: widget.adminName),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sélectionner un département",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedDepId,
                          onChanged: (value) {
                            setState(() {
                              selectedDepId = value;
                            });
                          },
                          items:
                              departments.map((dept) {
                                return DropdownMenuItem<String>(
                                  value: dept["depid"],
                                  child: Text(dept["name"]!),
                                );
                              }).toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Sélectionner un semestre",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedSemester,
                          onChanged: (value) {
                            setState(() {
                              selectedSemester = value;
                            });
                          },
                          items:
                              semesters.map((sem) {
                                return DropdownMenuItem<String>(
                                  value: sem,
                                  child: Text(sem),
                                );
                              }).toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: "Nom",
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? "Entrez le nom de l'étudiant" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: "Nom d'utilisateur",
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? "Entrez le nom d'utilisateur" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: "Email (Gmail uniquement)",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer une adresse e-mail';
                            }
                            if (!_gmailRegex.hasMatch(value)) {
                              return 'Veuillez entrer une adresse Gmail valide\n(exemple@gmail.com)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Mot de passe",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un mot de passe';
                            }
                            if (value.length < 8) {
                              return 'Le mot de passe doit contenir au moins 8 caractères';
                            }
                            if (!_passwordRegex.hasMatch(value)) {
                              return 'Le mot de passe doit inclure :\n- Une lettre majuscule\n- Une lettre minuscule\n- Un chiffre\n- Un caractère spécial';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: addStudent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Ajouter un étudiant",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              UploadStudents(adminName: widget.adminName),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(17),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Importer un fichier Excel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
