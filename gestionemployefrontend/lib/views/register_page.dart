import 'package:flutter/material.dart';
import 'package:gestionemployefrontend/controllers/AuthController.dart';
import 'package:gestionemployefrontend/views/login_page.dart';
import 'package:gestionemployefrontend/views/widgets/input_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_add,
                size: 60,
              ),
              const SizedBox(height: 10),
              Text(
                'Inscription',
                style: GoogleFonts.roboto(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              InputWidget(
                  hintText: 'Name',
                  controller: _nameController,
                  obscureText: false),
              const SizedBox(height: 20),
              InputWidget(
                  hintText: 'Username',
                  controller: _usernameController,
                  obscureText: false),
              const SizedBox(height: 20),
              InputWidget(
                hintText: 'Email',
                obscureText: false,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email ou nom d\'utilisateur';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    Get.snackbar('Error', "l'address mail entré n'est pas valide, veuillez ressayer",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              InputWidget(
                hintText: 'Password',
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 20),
              InputWidget(
                hintText: 'Confirm Password',
                obscureText: true,
                controller: _passwordConfirmationController,
              ),
              const SizedBox(height: 20),
              Obx(() {
                return _authController.isLoading.value
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
                          if (_passwordController.text !=
                              _passwordConfirmationController.text) {
                            Get.snackbar('Erreur',
                                'Les mots de passe ne sont pas identiques',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor:
                                    const Color.fromARGB(255, 237, 104, 94),
                                colorText: Colors.white);
                            return;
                          }
                          if (_nameController.text.isEmpty ||
                              _usernameController.text.isEmpty ||
                              _emailController.text.isEmpty ||
                              _passwordController.text.isEmpty ||
                              _passwordConfirmationController.text.isEmpty) {
                            Get.snackbar(
                                'Erreur', 'Veuillez remplir tous les champs',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor:
                                    const Color.fromARGB(255, 237, 104, 94),
                                colorText: Colors.white);
                          } else {
                            await _authController.register(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                name: _nameController.text.trim(),
                                username: _usernameController.text.trim());

                            Get.off(() => const LoginPage());
                          }
                        },
                        child: const Text("S'inscrire",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,),
                      ));
              }),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.to(() => const LoginPage());
                },
                child: Text('Vous avez déja un compte ? Se connecter',
                    style: GoogleFonts.poppins(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
