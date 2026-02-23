import 'package:flutter/material.dart';
import 'package:job_finder/models/job_model.dart';
import 'package:job_finder/models/company_model.dart';

class JobProvider extends ChangeNotifier {
  List<JobModel> _jobs = [];
  List<JobModel> _savedJobs = [];
  List<CompanyModel> _companies = [];
  final bool _isLoading = false;

  List<JobModel> get jobs => _jobs;
  List<JobModel> get savedJobs => _savedJobs;
  List<CompanyModel> get companies => _companies;
  bool get isLoading => _isLoading;

  JobProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _companies = [
      CompanyModel(
        id: '1',
        name: 'Smart',
        logo: 'assets/images/Smart .png',
        industry: 'Telecommunications',
        location: 'Phnom Penh, Cambodia',
        description:
            'Smart Axiata is a leading mobile telecommunications provider in Cambodia, offering mobile, internet, and digital services.',
        website: 'https://smart.com.kh',
        openPositions: 3,
      ),
      CompanyModel(
        id: '2',
        name: 'Wing',
        logo: 'assets/images/Wing.png',
        industry: 'Banking & Finance',
        location: 'Phnom Penh, Cambodia',
        description:
            'Wing Bank is a leading mobile banking and financial service provider in Cambodia.',
        website: 'https://wingbank.com.kh',
        openPositions: 4,
      ),
      CompanyModel(
        id: '3',
        name: 'Cellcard',
        logo: 'assets/images/Cellcard.png',
        industry: 'Telecommunications',
        location: 'Phnom Penh, Cambodia',
        description:
            'Cellcard is Cambodia\'s first and longest-serving mobile operator.',
        website: 'https://cellcard.com.kh',
        openPositions: 2,
      ),
      CompanyModel(
        id: '4',
        name: 'ABA Bank',
        logo: 'assets/images/ABA Bank.png',
        industry: 'Banking & Finance',
        location: 'Phnom Penh, Cambodia',
        description:
            'Advanced Bank of Asia Limited (ABA Bank) is one of the leading commercial banks in Cambodia.',
        website: 'https://ababank.com',
        openPositions: 6,
      ),
      CompanyModel(
        id: '5',
        name: 'Aceleda Bank',
        logo: 'assets/images/Aceleda bank.png',
        industry: 'Banking & Finance',
        location: 'Phnom Penh, Cambodia',
        description:
            'ACLEDA Bank is the largest commercial bank in Cambodia, providing a wide range of financial services.',
        website: 'https://acledabank.com.kh',
        openPositions: 5,
      ),
      CompanyModel(
        id: '6',
        name: 'Grab',
        logo: 'assets/images/Grab.png',
        industry: 'Technology',
        location: 'Phnom Penh, Cambodia',
        description:
            'Grab is Southeast Asia\'s leading superapp, offering ride-hailing, food delivery, and digital payments.',
        website: 'https://grab.com',
        openPositions: 4,
      ),
      CompanyModel(
        id: '7',
        name: 'PassApp',
        logo: 'assets/images/Passapp.png',
        industry: 'Technology',
        location: 'Phnom Penh, Cambodia',
        description:
            'PassApp is Cambodia\'s leading ride-hailing and delivery platform.',
        website: 'https://passapp.com',
        openPositions: 3,
      ),
    ];

    _jobs = [
      JobModel(
        id: '1',
        title: 'Senior Flutter Developer',
        companyName: 'Smart',
        companyLogo: 'assets/images/Smart .png',
        location: 'Phnom Penh',
        salary: '\$2,000 - \$3,000',
        type: 'Full-time',
        description:
            'We are looking for a Senior Flutter Developer to join our mobile team. You will be responsible for developing and maintaining high-quality mobile applications using Flutter framework.\n\nResponsibilities:\n• Design and build advanced applications for the Flutter platform\n• Collaborate with cross-functional teams to define, design, and ship new features\n• Work with outside data sources and APIs\n• Unit-test code for robustness, including edge cases, usability, and general reliability\n• Work on bug fixing and improving application performance',
        requirements: [
          '3+ years of Flutter development experience',
          'Strong knowledge of Dart programming language',
          'Experience with REST APIs and third-party libraries',
          'Familiarity with state management (Bloc/Provider)',
          'Experience with Git version control',
          'Good communication skills in English',
        ],
        postedDate: '2 days ago',
      ),
      JobModel(
        id: '2',
        title: 'UI/UX Designer',
        companyName: 'Grab',
        companyLogo: 'assets/images/Grab.png',
        location: 'Phnom Penh',
        salary: '\$1,500 - \$2,000',
        type: 'Full-time',
        description:
            'Grab is seeking a talented UI/UX Designer to create amazing user experiences for our digital products.\n\nResponsibilities:\n• Create user-centered designs by understanding business requirements\n• Create user flows, wireframes, prototypes and mockups\n• Design UI elements and tools such as navigation menus, search boxes, tabs and widgets\n• Develop UI mockups and prototypes that clearly illustrate how sites function and look',
        requirements: [
          '2+ years of UI/UX design experience',
          'Proficiency in Figma, Adobe XD, or Sketch',
          'Strong portfolio demonstrating design skills',
          'Understanding of mobile-first design principles',
          'Knowledge of HTML/CSS is a plus',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '3',
        title: 'Backend Developer',
        companyName: 'Wing',
        companyLogo: 'assets/images/Wing.png',
        location: 'Phnom Penh',
        salary: '\$1,800 - \$2,500',
        type: 'Full-time',
        description:
            'Wing Bank is looking for a Backend Developer to build and maintain our banking systems and APIs.\n\nResponsibilities:\n• Design and implement RESTful APIs\n• Write clean, maintainable, and efficient code\n• Ensure the best possible performance and quality of applications\n• Help maintain code quality, organization, and automatization',
        requirements: [
          '3+ years backend development experience',
          'Strong knowledge of Node.js or Java/Spring Boot',
          'Experience with SQL and NoSQL databases',
          'Understanding of microservices architecture',
          'Experience with cloud services (AWS/GCP)',
        ],
        postedDate: '3 days ago',
      ),
      JobModel(
        id: '4',
        title: 'Marketing Manager',
        companyName: 'Cellcard',
        companyLogo: 'assets/images/Cellcard.png',
        location: 'Phnom Penh',
        salary: '\$2,000 - \$3,500',
        type: 'Full-time',
        description:
            'Cellcard is seeking an experienced Marketing Manager to lead our marketing team and drive brand growth.\n\nResponsibilities:\n• Develop and implement marketing strategies\n• Manage marketing campaigns across multiple channels\n• Analyze market trends and competitor activities\n• Lead and mentor the marketing team',
        requirements: [
          '5+ years marketing experience',
          'Strong leadership and team management skills',
          'Experience with digital marketing tools',
          'Excellent communication skills in Khmer and English',
          'MBA or related degree preferred',
        ],
        postedDate: '5 days ago',
      ),
      JobModel(
        id: '5',
        title: 'Mobile App Developer',
        companyName: 'ABA Bank',
        companyLogo: 'assets/images/ABA Bank.png',
        location: 'Phnom Penh',
        salary: '\$1,500 - \$2,500',
        type: 'Full-time',
        description:
            'ABA Bank is looking for a Mobile App Developer to help build and maintain our mobile banking application.\n\nResponsibilities:\n• Develop mobile applications for iOS and Android\n• Collaborate with the design team to implement UI/UX\n• Integrate with backend services and APIs\n• Optimize application performance',
        requirements: [
          '2+ years mobile development experience',
          'Experience with Flutter or React Native',
          'Knowledge of RESTful APIs',
          'Understanding of mobile security best practices',
          'Experience with banking/fintech is a plus',
        ],
        postedDate: '1 week ago',
      ),
      JobModel(
        id: '6',
        title: 'Data Analyst',
        companyName: 'Aceleda Bank',
        companyLogo: 'assets/images/Aceleda bank.png',
        location: 'Phnom Penh',
        salary: '\$1,200 - \$1,800',
        type: 'Full-time',
        description:
            'Aceleda Bank is seeking a Data Analyst to help us make data-driven decisions.\n\nResponsibilities:\n• Collect, process, and analyze large datasets\n• Create reports and dashboards\n• Identify trends and patterns in data\n• Present findings to stakeholders',
        requirements: [
          '2+ years data analysis experience',
          'Proficiency in SQL and Python',
          'Experience with data visualization tools (Tableau, Power BI)',
          'Strong analytical and problem-solving skills',
          'Knowledge of statistics and machine learning is a plus',
        ],
        postedDate: '4 days ago',
      ),
      JobModel(
        id: '7',
        title: 'Driver Operations Lead',
        companyName: 'PassApp',
        companyLogo: 'assets/images/Passapp.png',
        location: 'Phnom Penh',
        salary: '\$1,000 - \$1,500',
        type: 'Full-time',
        description:
            'PassApp is looking for a Driver Operations Lead to manage and optimize our driver network.\n\nResponsibilities:\n• Manage driver onboarding and training\n• Monitor driver performance and satisfaction\n• Optimize driver allocation and routing\n• Handle driver support and escalations',
        requirements: [
          '3+ years operations management experience',
          'Strong leadership and communication skills',
          'Experience with logistics or ride-hailing platforms',
          'Data-driven decision making skills',
          'Fluent in Khmer and English',
        ],
        postedDate: '6 days ago',
      ),
      JobModel(
        id: '8',
        title: 'Graphic Designer',
        companyName: 'Wing',
        companyLogo: 'assets/images/Wing.png',
        location: 'Phnom Penh',
        salary: '\$800 - \$1,200',
        type: 'Part-time',
        description:
            'Wing Bank is looking for a creative Graphic Designer to join our marketing team.\n\nResponsibilities:\n• Create visual content for marketing campaigns\n• Design social media graphics and banners\n• Develop brand materials and guidelines\n• Collaborate with the marketing team',
        requirements: [
          '1+ years graphic design experience',
          'Proficiency in Adobe Creative Suite',
          'Strong portfolio of design work',
          'Creative thinking and attention to detail',
          'Knowledge of print and digital design',
        ],
        postedDate: '2 days ago',
      ),
      JobModel(
        id: '9',
        title: 'Software Engineer',
        companyName: 'Grab',
        companyLogo: 'assets/images/Grab.png',
        location: 'Phnom Penh',
        salary: '\$2,000 - \$3,500',
        type: 'Full-time',
        description:
            'Grab is looking for a Software Engineer to build scalable backend systems.\n\nResponsibilities:\n• Design and develop microservices\n• Write clean and efficient code\n• Participate in code reviews\n• Collaborate with product and design teams',
        requirements: [
          '3+ years software engineering experience',
          'Proficiency in Go, Java, or Python',
          'Experience with distributed systems',
          'Knowledge of cloud platforms (AWS/GCP)',
          'Strong problem-solving skills',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '10',
        title: 'Customer Service Manager',
        companyName: 'Smart',
        companyLogo: 'assets/images/Smart .png',
        location: 'Siem Reap',
        salary: '\$1,200 - \$1,800',
        type: 'Full-time',
        description:
            'Smart is looking for a Customer Service Manager to lead our support team.\n\nResponsibilities:\n• Manage customer service operations\n• Train and mentor support staff\n• Handle escalated customer issues\n• Improve customer satisfaction metrics',
        requirements: [
          '3+ years customer service experience',
          'Strong leadership skills',
          'Excellent communication in Khmer and English',
          'Experience with CRM systems',
          'Problem-solving mindset',
        ],
        postedDate: '3 days ago',
      ),
    ];
    notifyListeners();
  }

  JobModel? getJobById(String id) {
    try {
      return _jobs.firstWhere((job) => job.id == id);
    } catch (e) {
      return null;
    }
  }

  CompanyModel? getCompanyByName(String name) {
    try {
      return _companies.firstWhere((c) => c.name == name);
    } catch (e) {
      return null;
    }
  }

  CompanyModel? getCompanyById(String id) {
    try {
      return _companies.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  List<JobModel> getJobsByCompany(String companyName) {
    return _jobs.where((job) => job.companyName == companyName).toList();
  }

  void toggleSaveJob(String jobId) {
    final index = _jobs.indexWhere((job) => job.id == jobId);
    if (index != -1) {
      _jobs[index] = _jobs[index].copyWith(isSaved: !_jobs[index].isSaved);
      _savedJobs = _jobs.where((job) => job.isSaved).toList();
      notifyListeners();
    }
  }

  List<JobModel> searchJobs(String query) {
    if (query.isEmpty) return _jobs;
    return _jobs.where((job) {
      return job.title.toLowerCase().contains(query.toLowerCase()) ||
          job.companyName.toLowerCase().contains(query.toLowerCase()) ||
          job.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<String> get categories => [
    'Technology',
    'Design',
    'Marketing',
    'Finance',
    'Management',
    'Data Science',
  ];
}
