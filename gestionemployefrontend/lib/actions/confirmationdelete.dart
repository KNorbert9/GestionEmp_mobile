import 'package:flutter/material.dart';

import '../controllers/EmployeController.dart';
import '../models/EmployeModel.dart';

Future<void> _showDeleteConfirmationDialog(
    BuildContext context, EmployeModel employe) async {
  EmployeController employeController = EmployeController();
  return showDialog<void>(
    context: context,
    barrierDismissible:
        false, // L'utilisateur ne peut pas fermer le popup en tapant à l'extérieur
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
              Navigator.of(context).pop(); // Ferme le popup
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // Action à effectuer lorsque l'utilisateur confirme la suppression
              if (employe.id != null) {
                employeController.deleteEmploye(id: employe.id!);
              } // Suppression de l'employé
              Navigator.of(context).pop(); // Ferme le popup
            },
            child: const Text('Supprimer'),
          ),
        ],
      );
    },
  );
}
