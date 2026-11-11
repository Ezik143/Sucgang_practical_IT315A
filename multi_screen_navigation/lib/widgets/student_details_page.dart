import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/student/student.dart';
import 'package:multi_screen_navigation/widgets/add_student_page.dart';

class StudentDetailsPage extends StatelessWidget {
  final Student student;
  const StudentDetailsPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("student information")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'student ID: ${student.studentId}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'name: ${student.name}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'year level: ${student.yearLevel}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'course: ${student.course}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'email: ${student.email}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'hobby: ${student.hobby}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'favorite subject: ${student.favoriteSubject}',
                  style: TextStyle(color: Colors.white),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final updatedStudent =
                            await showModalBottomSheet<Student>(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: (_) => AddStudentPage(student: student),
                            );

                        if (!context.mounted || updatedStudent == null) {
                          return;
                        }

                        Navigator.of(context).pop(updatedStudent);
                      },
                      child: Text("Edit"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
