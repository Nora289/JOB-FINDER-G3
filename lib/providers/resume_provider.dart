import 'package:flutter/material.dart';

class ExperienceItem {
  String title, company, period, description;
  ExperienceItem({
    required this.title,
    required this.company,
    required this.period,
    required this.description,
  });
}

class EducationItem {
  String degree, school, period, field;
  EducationItem({
    required this.degree,
    required this.school,
    required this.period,
    required this.field,
  });
}

class ResumeProvider extends ChangeNotifier {
  bool _isUploaded = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadedFileName = '';
  String _uploadedFileSize = '';
  final String portfolioUrl = 'github.com/username';

  final List<ExperienceItem> _experiences = [
    ExperienceItem(
      title: 'Flutter Developer',
      company: 'ABA Bank',
      period: 'Jan 2023 – Present',
      description:
          'Developed and maintained mobile banking app using Flutter & Dart.',
    ),
    ExperienceItem(
      title: 'Junior Mobile Developer',
      company: 'Smart Axiata',
      period: 'Jun 2021 – Dec 2022',
      description:
          'Built UI components and integrated REST APIs for telecom services.',
    ),
  ];

  final List<EducationItem> _educations = [
    EducationItem(
      degree: 'Bachelor of Computer Science',
      school: 'Royal University of Phnom Penh',
      period: '2018 – 2022',
      field: 'Software Engineering',
    ),
  ];

  final List<String> _skills = [
    'Flutter', 'Dart', 'Firebase', 'REST API', 'Git', 'UI/UX', 'Figma',
  ];

  // ── Getters ─────────────────────────────────────────────────
  bool get isUploaded => _isUploaded;
  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;
  String get uploadedFileName => _uploadedFileName;
  String get uploadedFileSize => _uploadedFileSize;

  List<ExperienceItem> get experiences => List.unmodifiable(_experiences);
  List<EducationItem> get educations => List.unmodifiable(_educations);
  List<String> get skills => List.unmodifiable(_skills);

  int get completionPercent {
    int s = 0;
    if (_isUploaded) s += 30;
    if (_experiences.isNotEmpty) s += 25;
    if (_educations.isNotEmpty) s += 20;
    if (_skills.isNotEmpty) s += 15;
    if (portfolioUrl.isNotEmpty) s += 10;
    return s;
  }

  // ── Upload ───────────────────────────────────────────────────
  void startUpload() {
    _isUploading = true;
    _uploadProgress = 0.0;
    notifyListeners();
    _tick();
  }

  void _tick() async {
    await Future.delayed(const Duration(milliseconds: 60));
    _uploadProgress += 0.025;
    if (_uploadProgress >= 1.0) {
      _isUploading = false;
      _isUploaded = true;
      _uploadedFileName = 'My_Resume_2024.pdf';
      _uploadedFileSize = '357 KB';
      notifyListeners();
    } else {
      notifyListeners();
      _tick();
    }
  }

  void removeFile() {
    _isUploaded = false;
    _isUploading = false;
    _uploadProgress = 0.0;
    _uploadedFileName = '';
    _uploadedFileSize = '';
    notifyListeners();
  }

  // ── Experience ───────────────────────────────────────────────
  void addExperience(ExperienceItem exp) {
    _experiences.insert(0, exp);
    notifyListeners();
  }

  void removeExperience(int index) {
    _experiences.removeAt(index);
    notifyListeners();
  }

  // ── Education ────────────────────────────────────────────────
  void addEducation(EducationItem edu) {
    _educations.insert(0, edu);
    notifyListeners();
  }

  void removeEducation(int index) {
    _educations.removeAt(index);
    notifyListeners();
  }

  // ── Skills ───────────────────────────────────────────────────
  void addSkill(String skill) {
    if (skill.trim().isNotEmpty && !_skills.contains(skill.trim())) {
      _skills.add(skill.trim());
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    _skills.remove(skill);
    notifyListeners();
  }
}
