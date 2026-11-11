import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/student/student.dart';
import 'package:multi_screen_navigation/student/student_data.dart';
import 'package:multi_screen_navigation/widgets/add_student_page.dart';
import 'package:multi_screen_navigation/widgets/student_details_page.dart';
import 'package:multi_screen_navigation/widgets/student_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _studentsStorageKey = 'students';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/student-details": (context) {
          final student = ModalRoute.of(context)!.settings.arguments as Student;

          return StudentDetailsPage(student: student);
        },
        "/add-student": (context) => const AddStudentPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      home: const StudentListPage(),
    );
  }
}

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final preferences = await SharedPreferences.getInstance();
    final savedStudents = preferences.getString(_studentsStorageKey);

    if (savedStudents != null && savedStudents.isNotEmpty) {
      final decodedStudents = jsonDecode(savedStudents);

      if (decodedStudents is! List) {
        throw const FormatException('Saved student records must be a list');
      }

      students = decodedStudents.map((record) {
        if (record is! Map) {
          throw const FormatException('Saved student record is invalid');
        }

        return Student.fromJson(Map<String, dynamic>.from(record));
      }).toList();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveStudents() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _studentsStorageKey,
      jsonEncode(students.map((student) => student.toJson()).toList()),
    );

    if (!saved) {
      throw StateError('Student records could not be saved');
    }
  }

  void _showSaveError(Object error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Student records could not be saved: $error')),
    );
  }

  Future<void> _updateStudent(
    Student originalStudent,
    Student updatedStudent,
  ) async {
    final index = students.indexWhere(
      (student) => student.studentId == originalStudent.studentId,
    );

    if (index == -1) return;

    setState(() {
      students[index] = updatedStudent;
    });

    try {
      await _saveStudents();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        students[index] = originalStudent;
      });
      _showSaveError(error);
    }
  }

  Future<void> _deleteStudent(Student student) async {
    final index = students.indexWhere(
      (currentStudent) => currentStudent.studentId == student.studentId,
    );

    if (index == -1) return;

    final removedStudent = students[index];
    setState(() {
      students.removeAt(index);
    });

    try {
      await _saveStudents();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        students.insert(index, removedStudent);
      });
      _showSaveError(error);
    }
  }

  Future<void> _openAddStudentPage() async {
    final Student? newStudent = await Navigator.of(
      context,
    ).push<Student>(MaterialPageRoute(builder: (_) => const AddStudentPage()));

    if (!mounted) return;

    if (newStudent != null) {
      setState(() {
        students.add(newStudent);
      });

      try {
        await _saveStudents();
      } catch (error) {
        if (!mounted) return;
        setState(() {
          students.remove(newStudent);
        });
        _showSaveError(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student List')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _openAddStudentPage,
              child: const Text("Add Student"),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];

                        return StudentListItem(
                          student: student,
                          onStudentUpdated: _updateStudent,
                          onStudentDeleted: _deleteStudent,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
