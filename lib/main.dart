import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion/Inscription"),
      ),
      body: Center(
        child: const Text("Prochainnement disponible"),
      )
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Room Manager"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/logo.svg",
              colorFilter:
                  const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            const Text(
              "Room Manager",
              style: TextStyle(fontSize: 42, fontFamily: 'Poppins'),
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
                  backgroundColor: MaterialStatePropertyAll(Colors.green)
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:( _, __, ___) => EventPage()
                      )
                  );
                },
                child: const Text("Page de connexion",
                style: TextStyle(
                  fontSize: 20
                )))
          ],
        )));
  }
}
