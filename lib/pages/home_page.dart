import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:room_manager/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime la flèche de retour
        title: const Text('Accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/logo.svg",
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            const Text(
              "Application de gestion de salles de classes.",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => LoginPage(),
                  ),
                );
              },
              child: const Text(
                "Se connecter/S'inscrire",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
