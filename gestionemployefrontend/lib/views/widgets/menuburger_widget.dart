import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class menuBurger_widget extends StatelessWidget {
  const menuBurger_widget({
    super.key,
    required this.pageRequis,
    required this.pageIcon,
    required this.action,
    required this.actionIcone,
    required this.actionIconeColor,
    required this.pageName,
    required this.onMenuTap,
    // required this.menuColor,
  });

  final Widget pageRequis;
  final Widget pageIcon;
  final VoidCallback action;
  final String pageName;
  final IconData actionIcone;
  final Color actionIconeColor;
  final void Function() onMenuTap;
  // final Color? menuColor;

  @override
Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 100, // Hauteur réduite du DrawerHeader
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: pageIcon, // Icône de profil
            title: Text(
              pageName,
              style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onMenuTap,
            // {
            //   Get.to(
            //     () => pageRequis,
            //     transition: Transition.fadeIn,
            //     duration: const Duration(milliseconds: 1000),
            //     curve: Curves.easeInOut,
                
            //   );
            // },
          ),
          const Divider(), // Ajout d'une ligne de séparation
          ListTile(
            leading: Icon(
              actionIcone,
              color: actionIconeColor,
            ),
             // Icône de déconnexion
            title: Text(
              'Se déconnecter',
              style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            trailing: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            dense: true,
            onTap: action, // Utilisation de la fonction de déconnexion
          ),
        ],
      ),
    );
  }
}
