import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:room_manager/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/logo.svg",
              colorFilter:
              const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            const Text(
              "Application de gestion de salles de classes.",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:( _, __, ___) => LoginPage()
                      )
                  );
                },
                child: const Text("Se connecter/S'inscrire",
                    style: TextStyle(
                        fontSize: 20
                    )))
          ],
        ));
  }
}