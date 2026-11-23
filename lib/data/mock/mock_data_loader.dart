import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../repositories/repositories.dart';
import 'mock_auth_repository.dart';
import 'mock_parent_repository.dart';
import 'mock_student_repository.dart';
import 'mock_teacher_repository.dart';

/// Loads every mock repository from its JSON file in `assets/mock_data/`.
///
/// All dummy data — people, timetables, lessons, messages, notifications —
/// lives in those three files, not in Dart source, so it can be edited or
/// swapped without touching app code. Called once at startup in `main.dart`;
/// the resulting repositories are then handed to the app as fixed provider
/// overrides, which keeps every screen's `ref.watch(...Provider)` synchronous.
class MockData {
  const MockData({
    required this.parent,
    required this.student,
    required this.teacher,
    required this.auth,
  });

  final ParentRepository parent;
  final StudentRepository student;
  final TeacherRepository teacher;
  final AuthRepository auth;

  static Future<MockData> load() async {
    final results = await Future.wait([
      _loadJson('assets/mock_data/parent.json'),
      _loadJson('assets/mock_data/student.json'),
      _loadJson('assets/mock_data/teacher.json'),
      _loadJson('assets/mock_data/users.json'),
    ]);

    return MockData(
      parent: MockParentRepository.fromJson(results[0]),
      student: MockStudentRepository.fromJson(results[1]),
      teacher: MockTeacherRepository.fromJson(results[2]),
      auth: MockAuthRepository.fromJson(results[3]),
    );
  }

  static Future<Map<String, dynamic>> _loadJson(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
