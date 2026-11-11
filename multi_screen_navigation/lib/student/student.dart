class Student {
  final String studentId;
  final String name;
  final int yearLevel;
  final String course;
  final String email;
  final String hobby;
  final String favoriteSubject;
  final String status;

  Student({
    required this.studentId,
    required this.name,
    required this.yearLevel,
    required this.course,
    this.email = '',
    this.hobby = 'Not provided',
    this.favoriteSubject = 'Not provided',
    this.status = 'Active',
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'name': name,
      'yearLevel': yearLevel,
      'course': course,
      'email': email,
      'hobby': hobby,
      'favoriteSubject': favoriteSubject,
      'status': status,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    final studentId = json['studentId'];
    final name = json['name'];
    final yearLevel = json['yearLevel'];
    final course = json['course'];
    final email = json['email'];
    final hobby = json['hobby'];
    final favoriteSubject = json['favoriteSubject'];
    final status = json['status'];

    if (studentId is! String ||
        name is! String ||
        yearLevel is! int ||
        course is! String ||
        email is! String ||
        hobby is! String ||
        favoriteSubject is! String ||
        status is! String) {
      throw const FormatException('Saved student record has invalid fields');
    }

    return Student(
      studentId: studentId,
      name: name,
      yearLevel: yearLevel,
      course: course,
      email: email,
      hobby: hobby,
      favoriteSubject: favoriteSubject,
      status: status,
    );
  }
}
