import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/student/student.dart';
import 'package:multi_screen_navigation/student/student_data.dart';

class AddStudentPage extends StatefulWidget {
  final Student? student;

  const AddStudentPage({super.key, this.student});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _studentId = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _course = TextEditingController();
  // final TextEditingController _yearLevel = TextEditingController();
  final TextEditingController _emailAddress = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _yearLevel;

  bool get _isEditing => widget.student != null;

  @override
  void initState() {
    super.initState();

    final student = widget.student;
    if (student != null) {
      _studentId.text = student.studentId;
      _fullName.text = student.name;
      _course.text = student.course;
      _emailAddress.text = student.email;
      _yearLevel = student.yearLevel;
    }
  }

  void _submitStudent() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        studentId: _studentId.text.trim(),
        name: _fullName.text.trim(),
        course: _course.text.trim(),
        yearLevel: _yearLevel!,
        email: _emailAddress.text.trim(),
        hobby: widget.student?.hobby ?? 'Not provided',
        favoriteSubject: widget.student?.favoriteSubject ?? 'Not provided',
        status: widget.student?.status ?? 'Active',
      );

      Navigator.pop(context, student);
    }
  }

  @override
  void dispose() {
    _studentId.dispose();
    _fullName.dispose();
    _course.dispose();
    _emailAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? "Edit student" : "Add student")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _studentId,
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                    hintText: 'Student ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Student ID is required';
                    }

                    final exist = students.any((student) {
                      if (student.studentId == widget.student?.studentId) {
                        return false;
                      }

                      return student.studentId.toLowerCase() ==
                          value.trim().toLowerCase();
                    });

                    if (exist) {
                      return 'student Id already exist';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: _fullName,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _course,
                  decoration: InputDecoration(
                    labelText: 'Course',
                    hintText: 'Course',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Course is required';
                    }
                    return null;
                  },
                ),

                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Year Level',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('1st Year')),
                    DropdownMenuItem(value: 2, child: Text('2nd Year')),
                    DropdownMenuItem(value: 3, child: Text('3rd Year')),
                    DropdownMenuItem(value: 4, child: Text('4th Year')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _yearLevel = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value == 0) {
                      return 'Please select a year level';
                    }
                    return null;
                  },
                ),
                // TextFormField(
                //   controller: _yearLevel,
                //   decoration: InputDecoration(
                //     labelText: 'Year Level',
                //     hintText: 'Year Level',
                //     border: OutlineInputBorder(),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Year level is required';
                //     }
                //     return null;
                //   },
                // ),
                TextFormField(
                  controller: _emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email Address is required';
                    }

                    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                    if (!emailPattern.hasMatch(value.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),

                ElevatedButton(
                  onPressed: _submitStudent,
                  child: Text(_isEditing ? 'Save Changes' : 'Add Student'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
