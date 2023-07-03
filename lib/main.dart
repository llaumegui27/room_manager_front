import 'package:flutter/material.dart';
import 'package:room_manager/pages/event_page.dart';
import 'package:room_manager/pages/home_page.dart';
import 'package:room_manager/pages/reservation_page.dart';
import 'package:room_manager/pages/request_room_page.dart';
import 'package:room_manager/pages/user_manager.dart';
import 'package:room_manager/pages/my_requests_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.initialIndex = 0}) : super(key: key);
  final int initialIndex;

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
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: [
              const Text("Liste des salles"),
              const Text("Demande de réservation de salles"),
              if (UserManager().isAdmin == true) const Text("Liste des demandes"),
              if (UserManager().isAdmin == false) const Text("Mes demandes")
            ][_currentIndex],
            actions: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ],
          ),
          body: [
            EventPage(),
            ReservationPage(),
            if (UserManager().isAdmin == true) RequestRoomPage(),
            if (UserManager().isAdmin == false) MyRequestPage()
          ][_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setCurrentIndex(index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            iconSize: 28,
            elevation: 10,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Salles',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Réservation',
              ),
              if (UserManager().isAdmin == false) // Ajoutez cette condition
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'Mes demandes',
                ),
              if (UserManager().isAdmin == true) // Ajoutez cette condition
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'Liste des demandes',
                ),
            ],
          ),

        ),
      ),
    );
  }
}
