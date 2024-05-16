import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestionemployefrontend/constants/constants.dart';
import 'package:gestionemployefrontend/models/EmployeModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class EmployeController extends GetxController {
  final Employes = [].obs;

  final isLoading = false.obs;

  final box = GetStorage();

  final token = ''.obs;

  @override
  void onInit() {
    getAllEmployes();
    super.onInit();
  }

  Future addEmploye({
    required String lastname,
    required String firstname,
    required String email,
  }) async {
    try {
      isLoading.value = true;
      var data = {'lastname': lastname, 'firstname': firstname, 'email': email};

      var response = await http.post(Uri.parse('${url}employes'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${box.read('token')}'
          },
          body: data);
      if (response.statusCode == 201) {
        isLoading.value = false;
        Get.snackbar('Good', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 94, 237, 101),
            colorText: Colors.white);
        getAllEmployes();
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
        print(e);
      }
      Get.snackbar(
        'Error',
        'Failed to add employe. Please try again later. ////////',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(255, 237, 104, 94),
        colorText: Colors.white,
      );
    }
  }

  Future getAllEmployes() async {
    try {
      isLoading.value = true;

      var response = await http.get(Uri.parse('${url}employes'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}'
      });

      if (response.statusCode == 200) {
        isLoading.value = false;
        Employes.value = (jsonDecode(response.body)['employes'] as List)
            .map((e) => EmployeModel.fromJson(e))
            .toList();
        Employes.sort((a, b) => a.lastname.compareTo(b.lastname));
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
        print(e);
      }
      Get.snackbar(
        'Error',
        'Failed to fetch employes. Please try again later. ////////',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(255, 237, 104, 94),
        colorText: Colors.white,
      );
    }
  }

  Future getEmploye({required int id}) async {
    try {
      var response = await http.get(Uri.parse('${url}employe/$id'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}'
      });

      if (response.statusCode == 200) {
        return EmployeModel.fromJson(jsonDecode(response.body)['employe']);
      } else {
        Get.snackbar('Error', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 237, 104, 94),
            colorText: Colors.white);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future deleteEmploye({required int id}) async {
    try {
      var response = await http.delete(Uri.parse('${url}employes/$id'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${box.read('token')}'
          });

      if (response.statusCode == 200) {
        Get.snackbar('Good', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 94, 237, 101),
            colorText: Colors.white);
        getAllEmployes();
      } else {
        Get.snackbar('Error', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 237, 104, 94),
            colorText: Colors.white);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future updateEmploye(
      {required int id,
      required String lastname,
      required String firstname,
      required String email}) async {
    try {
      var response = await http.put(Uri.parse('${url}employes/$id'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}'
      }, body: {
        'lastname': lastname,
        'firstname': firstname,
        'email': email
      });

      if (response.statusCode == 200) {
        Get.snackbar('Good', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 94, 237, 101),
            colorText: Colors.white);
        getAllEmployes();
      } else {
        Get.snackbar('Error', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 237, 104, 94),
            colorText: Colors.white);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> searchEmployes(String query) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${url}employes/search?query=$query'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}'
        },
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        final List<dynamic> responseData = jsonDecode(response.body)['employes'];
        Employes.value = responseData.map((e) => EmployeModel.fromJson(e)).toList();
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
        print(e);
      }
      Get.snackbar(
        'Error',
        'Failed to fetch employes. Please try again later. ////////',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(255, 237, 104, 94),
        colorText: Colors.white,
      );
    }
  }
}
