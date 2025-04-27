import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_aplikasi_sederhana/main.dart';

void main() {
  testWidgets('Judul aplikasi muncul di widget', (WidgetTester tester) async {
    // Membangun widget MyApp
    await tester.pumpWidget(const MyApp());

    // Mencari teks 'Aplikasi Flutter Sederhana' di dalam widget tree
    expect(find.text('Aplikasi Flutter Sederhana'), findsOneWidget);
  });

  testWidgets('BottomNavigationBar muncul dan dapat diganti', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Pastikan bottom navigation ada
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Klik tab kedua (API)
    await tester.tap(find.byIcon(Icons.cloud));
    await tester.pump(); // Trigger rebuild

    // Tambahkan pengecekan lebih lanjut jika perlu
  });
}
