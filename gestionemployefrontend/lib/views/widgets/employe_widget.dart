import 'package:flutter/material.dart';
import 'package:gestionemployefrontend/controllers/EmployeController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EmployePost extends StatelessWidget {
  EmployePost({
    super.key,
    required this.employeController,
  });

  final EmployeController employeController;
  final _lastnameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (employeController.Employes.isEmpty) {
        return const Center(
          child: Text('Aucun employé trouvé.'),
        );
      } else {
        // Tri de la liste des employés par ordre alphabétique
        employeController.Employes.sort((a, b) => a.lastname.compareTo(b.lastname));
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemCount: employeController.Employes.length,
            itemBuilder: (context, index) {
              var employe = employeController.Employes[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 234, 226, 226),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    '${employe.lastname} ${employe.firstname}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employe.email,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Créé le ${DateFormat('dd/MM/yyyy').format(employe.createdAt)}', // Affichage de la date de création
                        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _lastnameController.text = employe.lastname ?? '';
                          _firstnameController.text = employe.firstname ?? '';
                          _emailController.text = employe.email ?? '';
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
                                      'Mettre à jour un employé',
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
                                                await employeController.updateEmploye(
                                                  id: employe.id,
                                                  lastname: _lastnameController.text.trim(),
                                                  firstname: _firstnameController.text.trim(),
                                                  email: _emailController.text.trim(),
                                                );
                                                employeController.isLoading.value = false;
                                                _lastnameController.clear();
                                                _firstnameController.clear();
                                                _emailController.clear();
                                                Navigator.pop(context);
                                              },
                                              child: Obx(() => employeController.isLoading.value
                                                  ? const CircularProgressIndicator()
                                                  : const Text('Valider',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ))),
                                            );
                                    }),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, employe.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int employeId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Voulez-vous vraiment supprimer cet employé ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                employeController.deleteEmploye(id: employeId);
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
