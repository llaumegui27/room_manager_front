import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:room_manager/pages/event_page.dart';
import 'package:room_manager/pages/home_page.dart';
import 'package:room_manager/pages/login_page.dart';
import 'package:room_manager/pages/reservation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.initialIndex = 1}) : super(key: key);
  final int initialIndex;  // Ajout du paramètre initialIndex

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;

  setCurrentIndex(int index) {
    print(index);
    print(_currentIndex);
    setState(() {
      if (widget.initialIndex != _currentIndex) {
        print(index);
        _currentIndex = widget.initialIndex;
      } else {
        print(index);
        _currentIndex = index;
      }
      print(_currentIndex);
    });
  }

  @override
  void initState() {
    setCurrentIndex(_currentIndex);
    super.initState();
    print("l'index : $_currentIndex");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: [
            const Text("Accueil"),
            const Text("Liste des salles"),
            const Text("Demande de réservation de salles"),
          ][_currentIndex],
        ),
        body: [   //liste de pages
          HomePage(),
          EventPage(),
          ReservationPage(),
        ][_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          iconSize: 28,
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Salles'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Réservation'
            ),
          ],
        ),

      ),
    );
  }
}