import 'package:flutter/material.dart';

class CoverLetterProvider extends ChangeNotifier {
  String _recipientName = 'Hiring Manager';
  String _company = '';
  String _position = '';
  String _tone = 'Professional';
  String _opening = '';
  String _body = '';
  String _closing = '';
  bool _generated = false;

  String get recipientName => _recipientName;
  String get company => _company;
  String get position => _position;
  String get tone => _tone;
  String get opening => _opening;
  String get body => _body;
  String get closing => _closing;
  bool get generated => _generated;

  static const Map<String, String> templateBody = {
    'Professional':
        'I am writing to express my strong interest in the [Position] role at [Company]. '
        'With my background in mobile development and proven track record of delivering '
        'high-quality applications, I am confident I can make a significant contribution '
        'to your team.\n\n'
        'Throughout my career, I have developed expertise in Flutter & Dart, built '
        'scalable applications, and collaborated effectively in fast-paced environments. '
        'I am particularly drawn to [Company] because of its commitment to innovation '
        'and its impact on the Cambodian tech ecosystem.\n\n'
        'I welcome the opportunity to discuss how my skills and experiences align with '
        'your needs. Thank you for considering my application.',
    'Enthusiastic':
        'I am absolutely thrilled to apply for the [Position] position at [Company]! '
        'Your company\'s innovative approach and exciting projects make it exactly the '
        'kind of place where I know I can thrive and grow.\n\n'
        'My hands-on experience with Flutter, Dart, and Firebase has equipped me to '
        'hit the ground running. I love building apps that make a real difference in '
        'people\'s lives, and I believe [Company] is the perfect platform for that.\n\n'
        'I would love the chance to bring my energy and skills to your team. '
        'I look forward to hearing from you!',
    'Formal':
        'I respectfully submit my application for the position of [Position] at [Company]. '
        'Having reviewed the job requirements, I believe my qualifications and professional '
        'experience make me a suitable candidate for this role.\n\n'
        'My academic background in Computer Science, combined with practical experience '
        'in mobile application development, has provided me with the technical competencies '
        'and professional discipline required for this position.\n\n'
        'I would be grateful for the opportunity to further discuss my suitability for '
        'this role at your earliest convenience.',
    'Friendly':
        'Hi there! I came across the [Position] opening at [Company] and knew I had to '
        'apply — it sounds like a perfect fit!\n\n'
        'I have been building mobile apps with Flutter and Dart for a few years now, '
        'and I genuinely love what I do. I am a quick learner, a great team player, '
        'and I always bring positive energy to the projects I work on.\n\n'
        'I would love to chat and learn more about the team and the role. '
        'Looking forward to connecting!',
  };

  static const Map<String, String> templateOpening = {
    'Professional': 'Dear [Recipient Name],',
    'Enthusiastic': 'Dear [Recipient Name],',
    'Formal': 'Dear [Recipient Name],',
    'Friendly': 'Hi [Recipient Name],',
  };

  static const Map<String, String> templateClosing = {
    'Professional': 'Sincerely,',
    'Enthusiastic': 'With great excitement,',
    'Formal': 'Yours faithfully,',
    'Friendly': 'Cheers,',
  };

  void setFields({
    required String recipientName,
    required String company,
    required String position,
    required String tone,
  }) {
    _recipientName = recipientName;
    _company = company;
    _position = position;
    _tone = tone;
    notifyListeners();
  }

  void generate() {
    final comp = _company.trim().isEmpty ? '[Company]' : _company.trim();
    final pos = _position.trim().isEmpty ? '[Position]' : _position.trim();
    final rec = _recipientName.trim().isEmpty ? 'Hiring Manager' : _recipientName.trim();

    _body = (templateBody[_tone] ?? '')
        .replaceAll('[Company]', comp)
        .replaceAll('[Position]', pos);

    _opening = (templateOpening[_tone] ?? 'Dear [Recipient Name],')
        .replaceAll('[Recipient Name]', rec);

    _closing = templateClosing[_tone] ?? 'Sincerely,';
    _generated = true;
    notifyListeners();
  }

  void updateOpening(String v) { _opening = v; notifyListeners(); }
  void updateBody(String v) { _body = v; notifyListeners(); }
  void updateClosing(String v) { _closing = v; notifyListeners(); }

  String fullLetter(String userName) =>
      '$_opening\n\n$_body\n\n$_closing\n$userName';
}
