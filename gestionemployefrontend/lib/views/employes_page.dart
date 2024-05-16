import 'package:flutter/material.dart';
import 'package:gestionemployefrontend/controllers/AuthController.dart';
import 'package:gestionemployefrontend/controllers/EmployeController.dart';
import 'package:gestionemployefrontend/views/profile_page.dart';
import 'package:gestionemployefrontend/views/widgets/employe_widget.dart';
import 'package:get/get.dart';

import 'widgets/menuburger_widget.dart';

class EmployesPage extends StatefulWidget {
  const EmployesPage({super.key});

  @override
  State<EmployesPage> createState() => _EmployesPageState();
}

class _EmployesPageState extends State<EmployesPage> {
  final EmployeController employeController = Get.put(EmployeController());
  final AuthController authController = Get.put(AuthController());
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des employés'),
        centerTitle: true,
      ),
      drawer: menuBurger_widget(
        pageRequis: const ProfilePage(),
        pageName: "Profile",
        pageIcon: const Icon(Icons.person),
        action: authController.logout,
        actionIcone: Icons.logout,
        actionIconeColor: const Color.fromARGB(1, 233, 66, 66),
        onMenuTap: () {
          Get.to(
            () => const ProfilePage(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
        },
      ),
      body: EmployePost(employeController: employeController),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ajouter un employé',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _lastnameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _firstnameController,
                      decoration: const InputDecoration(
                        labelText: 'Prénom',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      return employeController.isLoading.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 20,
                                ),
                              ),
                              onPressed: () async {
                                employeController.isLoading.value = true;
                                await employeController.addEmploye(
                                  lastname: _lastnameController.text.trim(),
                                  firstname: _firstnameController.text.trim(),
                                  email: _emailController.text.trim(),
                                );
                                _lastnameController.clear();
                                _firstnameController.clear();
                                _emailController.clear();
                                employeController.isLoading.value = false;
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              },
                              child: Obx(() => employeController.isLoading.value
                                  ? const CircularProgressIndicator() 
                                  : const Text('Ajouter',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            );
                    })
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'Ajouter employé',
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
