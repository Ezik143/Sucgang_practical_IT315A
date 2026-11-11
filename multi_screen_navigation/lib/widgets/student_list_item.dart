import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/student/student.dart';
import 'package:multi_screen_navigation/widgets/student_details_page.dart';

class StudentListItem extends StatelessWidget {
  final Student student;
  final Future<void> Function(Student original, Student updated)?
  onStudentUpdated;
  final Future<void> Function(Student student)? onStudentDeleted;

  const StudentListItem({
    super.key,
    required this.student,
    this.onStudentUpdated,
    this.onStudentDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black38,
      child: InkWell(
        onTap: () async {
          final updatedStudent = await Navigator.of(context).push<Student>(
            MaterialPageRoute(
              builder: (_) => StudentDetailsPage(student: student),
            ),
          );

          if (updatedStudent != null) {
            await onStudentUpdated?.call(student, updatedStudent);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 50),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Delete student',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onStudentDeleted == null
                        ? null
                        : () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete student?'),
                                content: Text(
                                  'Remove ${student.name} from the student list?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (shouldDelete == true) {
                              await onStudentDeleted!(student);
                            }
                          },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'student ID: ${student.studentId}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'name: ${student.name}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'year level: ${student.yearLevel}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'course: ${student.course}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'email: ${student.email}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'hobby: ${student.hobby}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'favorite subject: ${student.favoriteSubject}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
