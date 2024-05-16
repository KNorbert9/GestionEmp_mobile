import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestionemployefrontend/views/employes_page.dart';
import 'package:gestionemployefrontend/views/splash_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:gestionemployefrontend/constants/constants.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final RxString emailForPasswordReset = ''.obs;

  final token = ''.obs;
  final box = GetStorage();

  final profilData = ''.obs;
  Future register(
      {required String email,
      required String password,
      required String name,
      required String username}) async {
    try {
      isLoading.value = true;
      var data = {
        'email': email,
        'password': password,
        'name': name,
        'username': username
      };

      var response = await http.post(Uri.parse('${url}register'),
          headers: {'Accept': 'application/json'}, body: data);

      if (response.statusCode == 201) {
        isLoading.value = false;
        Get.snackbar('Good', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 94, 237, 101),
            colorText: Colors.white);
        debugPrint(jsonDecode(response.body)['message']);
      } else {
        isLoading.value = false;
        Get.snackbar('Error', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 237, 104, 94),
            colorText: Colors.white);
        debugPrint(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future login({
    required String identity,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      var data = {'identity': identity, 'password': password};

      var response = await http.post(Uri.parse('${url}login'),
          headers: {'Accept': 'application/json'}, body: data);

      if (response.statusCode == 201) {
        isLoading.value = false;
        Get.snackbar('Good', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Color.fromARGB(255, 94, 237, 101),
            colorText: Colors.white);
        token.value = jsonDecode(response.body)['token'];
        box.write('token', token.value);
        Get.offAll(
          () => const EmployesPage(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      } else {
        isLoading.value = false;
        Get.snackbar('Error', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 237, 104, 94),
            colorText: Colors.white);
        print(jsonDecode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future<void> logout() async {
    await box.remove('token');
    Get.off(
      () => const SplashScreen(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    Get.snackbar('Good', 'Logout Successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(255, 94, 237, 101),
        colorText: Colors.white);
  }

  Future profile() async {
    try {
      isLoading.value = true;
      var response = await http.get(Uri.parse('${url}profile'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        return jsonDecode(response.body)['user'];
      } else {
        isLoading.value = false;
        Get.snackbar('Error', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 237, 104, 94),
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future updateProfile(
      {required String name,
      required String username,
      required String email}) async {
    try {
      isLoading.value = true;
      var data = {'name': name, 'username': username, 'email': email};
      var response = await http.put(Uri.parse('${url}updateProfile'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${box.read('token')}',
          },
          body: data);
      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar('Good', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 94, 237, 101),
            colorText: Colors.white);
        profile();
      } else {
        isLoading.value = false;
        Get.snackbar('Error', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 237, 104, 94),
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future forgotPassword({required String email}) async {
    try {
      isLoading.value = true;
      var data = {'email': email};
      var response =
          await http.post(Uri.parse('${url}forgotPassword'), body: data);
      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar('Good', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 94, 237, 101),
            colorText: Colors.white);
      } else {
        isLoading.value = false;
        Get.snackbar('Error', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 237, 104, 94),
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;

      var response = await http.delete(
        Uri.parse('${url}deleteAccount'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        box.remove('token');
        Get.off(
          () => const SplashScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        Get.snackbar('Success', 'Account deleted successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 94, 237, 101),
            colorText: Colors.white);
      } else {
        isLoading.value = false;
        Get.snackbar('Error', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 237, 104, 94),
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
