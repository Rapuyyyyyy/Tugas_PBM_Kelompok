import 'package:flutter/material.dart';
import 'package:flutter_aplikasi_sederhana/pages/halaman_api.dart';
import 'package:flutter_aplikasi_sederhana/pages/halaman_counter.dart';
import 'package:flutter_aplikasi_sederhana/pages/halaman_profil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Flutter Sederhana',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HalamanCounter(),
    const HalamanApi(),
    const HalamanProfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.exposure), label: 'Counter'),
          BottomNavigationBarItem(icon: Icon(Icons.api), label: 'API'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Profil'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

