import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Definisikan warna utama kita
  static const Color primaryColor = Color(0xFFE57373); // Merah-oranye lembut
  static const Color accentColor = Color(0xFFFFB74D);  // Oranye-kuning hangat
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);

  // Tema Terang (Light Mode)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: Colors.white,
      onSurface: Colors.black87,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black87),
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.light().textTheme,
    ),
    // PERBAIKAN: Nama kelas yang benar adalah CardThemeData
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
    ),
    // Hapus 'const' karena TextStyle di dalamnya tidak konstan
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey.shade400),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
    // PERBAIKAN: Nama kelas yang benar adalah TabBarThemeData
    tabBarTheme: const TabBarThemeData(
      labelColor: primaryColor,
      unselectedLabelColor: Colors.grey,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 3.0),
      ),
    ),
  );

  // Tema Gelap (Dark Mode)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white70,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.white70),
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ),
    // PERBAIKAN: Nama kelas yang benar adalah CardThemeData
    cardTheme: const CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey.shade600),
    ),
     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Color(0xFF1E1E1E),
    ),
     // PERBAIKAN: Nama kelas yang benar adalah TabBarThemeData
     tabBarTheme: const TabBarThemeData(
      labelColor: primaryColor,
      unselectedLabelColor: Colors.grey,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 3.0),
      ),
    ),
  );
}
