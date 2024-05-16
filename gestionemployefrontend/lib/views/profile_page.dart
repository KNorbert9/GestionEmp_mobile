import 'package:flutter/material.dart';
import 'package:gestionemployefrontend/controllers/AuthController.dart';
import 'package:gestionemployefrontend/views/employes_page.dart';
import 'package:gestionemployefrontend/views/login_page.dart';
import 'package:get/get.dart';

import 'widgets/menuburger_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authController = Get.put(AuthController());
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _emailModifController = TextEditingController();
  final _usernameModifController = TextEditingController();
  final _nameModifController = TextEditingController();

  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    initProfile();
  }

  void initProfile() async {
    profileData = await authController.profile();
    setState(() {
      _nameController.text = profileData?['name'] ?? '';
      _usernameController.text = profileData?['username'] ?? '';
      _emailController.text = profileData?['email'] ?? '';
      _emailModifController.text = profileData?['email'] ?? '';
      _usernameModifController.text = profileData?['username'] ?? '';
      _nameModifController.text = profileData?['name'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      drawer: menuBurger_widget(
        pageRequis: const EmployesPage(),
        pageName: "Home",
        pageIcon: const Icon(Icons.home),
        action: authController.logout,
        actionIcone: Icons.logout,
        actionIconeColor: const Color.fromARGB(1, 233, 66, 66),
        onMenuTap: () {
          Get.offAll(
            () => const EmployesPage(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _nameController.text.isNotEmpty
                  ? _nameController.text
                  : 'chargement ...', // Replace with actual name
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _usernameController.text.isNotEmpty
                  ? _usernameController.text
                  : 'chargement ...', // Replace with actual name
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _emailController.text.isNotEmpty
                  ? _emailController.text
                  : 'chargement ...', // Replace with actual email
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return authController.isLoading.value
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
                                    'Modifier votre profil',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _nameModifController,
                                    decoration: const InputDecoration(
                                      labelText: 'Nom',
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _usernameModifController,
                                    decoration: const InputDecoration(
                                      labelText: 'Username',
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _emailModifController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Obx(() {
                                    return authController.isLoading.value
                                        ? const CircularProgressIndicator()
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 50,
                                                vertical: 20,
                                              ),
                                            ),
                                            onPressed: () async {
                                              authController.isLoading.value =
                                                  true;
                                              await authController
                                                  .updateProfile(
                                                name: _nameModifController.text
                                                    .trim(),
                                                username:
                                                    _usernameModifController
                                                        .text
                                                        .trim(),
                                                email: _emailModifController
                                                    .text
                                                    .trim(),
                                              );
                                              authController.isLoading.value =
                                                  false;

                                              initProfile();

                                              Navigator.pop(context);
                                            },
                                            child: Obx(() => authController
                                                    .isLoading.value
                                                ? const CircularProgressIndicator()
                                                : const Text('Valider',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                          );
                                  })
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Text('Modifier le profil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    );
            }),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: const Text(
                          'Voulez-vous vraiment supprimer votre compte ? Cette action est irréversible.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Annuler'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop(true);
                            authController.isLoading.value = true;
                            await authController.deleteAccount();
                            authController.isLoading.value = false;
                            // Rediriger vers la page de login ou une autre page appropriée après la suppression du compte
                            Get.offAll(
                              () => const LoginPage(),
                              transition: Transition.fade,
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Supprimer',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 237, 104,
                    94), // Couleur adaptée pour le bouton Modifier le profil
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
              ),
              child: const Text('Supprimer le compte',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
