import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import yang diperlukan untuk testing database
import 'package:flutter_resep_masakan_nusantara_uas/data/database_helper.dart';
import 'package:flutter_resep_masakan_nusantara_uas/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Fungsi main untuk testing perlu diubah menjadi async untuk inisialisasi FFI.
Future<void> main() async {
  // 1. Inisialisasi FFI untuk sqflite.
  // Ini memungkinkan database berjalan di luar environment Android/iOS (misal: Windows/macOS/Linux).
  sqfliteFfiInit();

  // 2. Arahkan factory database untuk menggunakan implementasi FFI.
  databaseFactory = databaseFactoryFfi;

  testWidgets('App starts and shows Login Screen', (WidgetTester tester) async {
    // 3. Buat instance dari DatabaseHelper yang akan digunakan oleh aplikasi.
    final dbHelper = DatabaseHelper.instance;

    // 4. Build aplikasi kita dan berikan dbHelper yang dibutuhkan.
    // Error Anda sebelumnya terjadi di sini karena dbHelper tidak diberikan.
    await tester.pumpWidget(MyApp(dbHelper: dbHelper));
    
    // 5. Ubah logika test agar sesuai dengan aplikasi Anda.
    // Aplikasi Anda akan menampilkan LoginScreen, bukan counter.
    // Jadi, kita cek apakah ada widget dengan teks 'Selamat Datang'.
    expect(find.text('Selamat Datang'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    // Test counter bawaan sudah tidak relevan dan bisa dihapus.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);
  });
}
