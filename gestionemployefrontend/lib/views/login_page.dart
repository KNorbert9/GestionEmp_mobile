import 'package:flutter/material.dart';
import 'package:gestionemployefrontend/controllers/AuthController.dart';
import 'package:gestionemployefrontend/views/register_page.dart';
import 'package:gestionemployefrontend/views/widgets/input_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailSendController = TextEditingController();

  final _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.login,
                size: 60,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              Text(
                'Connexion',
                style: GoogleFonts.roboto(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              InputWidget(
                hintText: 'Email / Username',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    Get.snackbar('Error', 'Veuillez remplir tous les champs',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                  return null;
                },
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
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            Get.snackbar(
                                'Error', 'Veuillez remplir tous les champs',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                          } else {
                            await _authController.login(
                              identity: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          }
                        },
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
              }),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.to(() => const RegisterPage());
                },
                child: Text(
                  "Vous n'avez pas de compte ? Inscrivez-vous",
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Entrez votre adresse e-mail pour réinitialiser votre mot de passe',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              const SizedBox(height: 20.0),
                              TextField(
                                controller: _emailSendController,
                                decoration: const InputDecoration(
                                  labelText: 'Adresse e-mail',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Obx(() {
                                return _authController.isLoading.value
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 20,
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (_emailSendController.text == "") {
                                            Get.snackbar(
                                              'Erreur',
                                              'Veuillez entrer votre adresse e-mail',
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                            );
                                          } else {
                                            await _authController
                                                .forgotPassword(
                                                    email: _emailSendController
                                                        .text
                                                        .trim());
                                            Navigator.pop(context);
                                            _emailSendController.text = '';
                                          }
                                        },
                                        child: const Text(
                                          'Envoyer',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  'Mot de passe oublié?',
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
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
