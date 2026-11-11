import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_navigation/main.dart';
import 'package:multi_screen_navigation/student/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('loads saved students and removes deleted records', (
    tester,
  ) async {
    final savedStudent = Student(
      studentId: 'IT-TEST-001',
      name: 'Saved Student',
      yearLevel: 1,
      course: 'BS Information Technology',
      email: 'saved@example.com',
    );
    SharedPreferences.setMockInitialValues({
      'students': jsonEncode([savedStudent.toJson()]),
    });

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    expect(find.text('name: Saved Student'), findsOneWidget);
    await tester.tap(find.byTooltip('Delete student'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('students'), jsonEncode([]));

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    expect(find.text('name: Saved Student'), findsNothing);
  });

  testWidgets('rejects duplicate student IDs when adding', (tester) async {
    final existingStudent = Student(
      studentId: 'IT-TEST-001',
      name: 'Existing Student',
      yearLevel: 1,
      course: 'BS Information Technology',
      email: 'existing@example.com',
    );
    SharedPreferences.setMockInitialValues({
      'students': jsonEncode([existingStudent.toJson()]),
    });

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Student'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'IT-TEST-001');
    await tester.enterText(fields.at(1), 'Another Student');
    await tester.enterText(fields.at(2), 'BS Information Technology');
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1st Year').last);
    await tester.enterText(fields.at(3), 'another@example.com');
    await tester.tap(find.text('Add Student').last);
    await tester.pumpAndSettle();

    expect(find.text('student Id already exist'), findsOneWidget);
    expect(find.text('Another Student'), findsOneWidget);
  });
}
