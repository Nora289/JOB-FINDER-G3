import 'package:flutter/material.dart';
import 'package:job_finder/models/job_model.dart';
import 'package:job_finder/models/company_model.dart';
import 'package:job_finder/models/application_status.dart';

class JobProvider extends ChangeNotifier {
  List<JobModel> _jobs = [];
  List<JobModel> _savedJobs = [];
  final List<JobModel> _appliedJobs = [];
  List<CompanyModel> _companies = [];
  bool _isLoading = false;

  // ── Application Status Tracking ──
  final Map<String, ApplicationStatus> _applicationStatuses = {};

  Map<String, ApplicationStatus> get applicationStatuses =>
      Map.unmodifiable(_applicationStatuses);

  // ── Active filters ──
  String _filterCategory = 'All';
  String _filterType = 'All';
  String _filterExperience = 'All';
  String _filterLocation = 'All';
  String _sortBy = 'Newest'; // Newest, Salary High-Low, Salary Low-High
  double _filterSalaryMin = 0;
  double _filterSalaryMax = 5000;

  // ── Job Comparison list (max 3) ──
  final List<JobModel> _compareList = [];

  // ── Job Alerts ──
  final List<Map<String, String>> _jobAlerts = [];

  String get filterCategory => _filterCategory;
  String get filterType => _filterType;
  String get filterExperience => _filterExperience;
  String get filterLocation => _filterLocation;
  String get sortBy => _sortBy;
  double get filterSalaryMin => _filterSalaryMin;
  double get filterSalaryMax => _filterSalaryMax;
  List<JobModel> get compareList => List.unmodifiable(_compareList);
  List<Map<String, String>> get jobAlerts => List.unmodifiable(_jobAlerts);

  void setFilters({
    String? category,
    String? type,
    String? experience,
    String? location,
    String? sort,
    double? salaryMin,
    double? salaryMax,
  }) {
    if (category != null) _filterCategory = category;
    if (type != null) _filterType = type;
    if (experience != null) _filterExperience = experience;
    if (location != null) _filterLocation = location;
    if (sort != null) _sortBy = sort;
    if (salaryMin != null) _filterSalaryMin = salaryMin;
    if (salaryMax != null) _filterSalaryMax = salaryMax;
    notifyListeners();
  }

  void clearFilters() {
    _filterCategory = 'All';
    _filterType = 'All';
    _filterExperience = 'All';
    _filterLocation = 'All';
    _sortBy = 'Newest';
    _filterSalaryMin = 0;
    _filterSalaryMax = 5000;
    notifyListeners();
  }

  bool get hasActiveFilters =>
      _filterCategory != 'All' ||
      _filterType != 'All' ||
      _filterExperience != 'All' ||
      _filterLocation != 'All' ||
      _filterSalaryMin > 0 ||
      _filterSalaryMax < 5000;

  List<JobModel> get filteredJobs {
    var result = List<JobModel>.from(_jobs);
    if (_filterCategory != 'All') {
      result = result.where((j) => j.category == _filterCategory).toList();
    }
    if (_filterType != 'All') {
      result = result.where((j) => j.type == _filterType).toList();
    }
    if (_filterExperience != 'All') {
      result = result
          .where((j) => j.experienceLevel == _filterExperience)
          .toList();
    }
    if (_filterLocation != 'All') {
      result = result
          .where((j) => j.location.contains(_filterLocation))
          .toList();
    }
    if (_filterSalaryMin > 0 || _filterSalaryMax < 5000) {
      result = result.where((j) {
        final maxSal = _salaryMax(j).toDouble();
        return maxSal >= _filterSalaryMin && maxSal <= _filterSalaryMax;
      }).toList();
    }
    if (_sortBy == 'Salary High-Low') {
      result.sort((a, b) => _salaryMax(b).compareTo(_salaryMax(a)));
    } else if (_sortBy == 'Salary Low-High') {
      result.sort((a, b) => _salaryMax(a).compareTo(_salaryMax(b)));
    }
    return result;
  }

  int _salaryMax(JobModel j) {
    final nums = RegExp(r'\d+').allMatches(j.salary.replaceAll(',', ''));
    if (nums.isEmpty) return 0;
    return nums
        .map((m) => int.parse(m.group(0)!))
        .reduce((a, b) => a > b ? a : b);
  }

  List<JobModel> get jobs => _jobs;
  List<JobModel> get savedJobs => _savedJobs;
  List<JobModel> get appliedJobs => _appliedJobs;
  List<CompanyModel> get companies => _companies;
  bool get isLoading => _isLoading;
  List<JobModel> get urgentJobs => _jobs.where((job) => job.isUrgent).toList();

  JobProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _companies = [
      CompanyModel(
        id: '1',
        name: 'Passapp',
        logo: 'assets/images/Passapp.png',
        industry: 'Technology',
        location: 'Phnom Penh, Cambodia',
        description:
            'PassApp is Cambodia\'s leading ride-hailing and delivery platform, connecting passengers and drivers across the country.',
        website: 'https://passapp.com.kh',
        openPositions: 5,
        latitude: 11.5658,
        longitude: 104.9173,
        address:
            'No. 62, Monivong Blvd, Sangkat Srah Chak, Khan Daun Penh, Phnom Penh, Cambodia',
      ),
      CompanyModel(
        id: '2',
        name: 'Smart Axiata',
        logo: 'assets/images/Smart .png',
        industry: 'Telecommunications',
        location: 'Phnom Penh, Cambodia',
        description:
            'Smart Axiata is a leading mobile telecommunications provider in Cambodia.',
        website: 'https://smart.com.kh',
        openPositions: 3,
        latitude: 11.5730,
        longitude: 104.9215,
        address:
            'No. 1A, Street 228, Sangkat Toul Tumpung 1, Khan Chamkarmorn, Phnom Penh, Cambodia',
      ),
      CompanyModel(
        id: '3',
        name: 'Wing Bank',
        logo: 'assets/images/Wing.png',
        industry: 'Banking & Finance',
        location: 'Phnom Penh, Cambodia',
        description:
            'Wing Bank is a leading mobile banking service provider in Cambodia.',
        website: 'https://wingbank.com.kh',
        openPositions: 4,
        latitude: 11.5640,
        longitude: 104.9280,
        address:
            'No. 721, Preah Monivong Blvd, Sangkat Beung Keng Kang 3, Khan Chamkarmorn, Phnom Penh, Cambodia',
      ),
      CompanyModel(
        id: '4',
        name: 'Cellcard',
        logo: 'assets/images/Cellcard.png',
        industry: 'Telecommunications',
        location: 'Phnom Penh, Cambodia',
        description:
            'Cellcard is Cambodia\'s first and longest-serving mobile operator.',
        website: 'https://cellcard.com.kh',
        openPositions: 2,
        latitude: 11.5749,
        longitude: 104.9108,
        address:
            'No. 33, Preah Sihanouk Blvd, Sangkat Chey Chumneas, Khan Daun Penh, Phnom Penh, Cambodia',
      ),
      CompanyModel(
        id: '5',
        name: 'ABA Bank',
        logo: 'assets/images/ABA Bank.png',
        industry: 'Banking & Finance',
        location: 'Phnom Penh, Cambodia',
        description:
            'Advanced Bank of Asia Limited (ABA Bank) is one of the leading commercial banks in Cambodia.',
        website: 'https://ababank.com',
        openPositions: 6,
        latitude: 11.5614,
        longitude: 104.9156,
        address:
            'No. 148, Preah Sihanouk Blvd, Sangkat Boeung Keng Kang 1, Khan Chamkarmorn, Phnom Penh, Cambodia',
      ),
      CompanyModel(
        id: '6',
        name: 'Beltei University',
        logo: 'assets/images/Beltei university.png',
        industry: 'Education',
        location: 'Phnom Penh, Cambodia',
        description:
            'Beltei International University is one of the leading private universities in Cambodia, offering quality education in technology, business, and more.',
        website: 'https://beltei.edu.kh',
        openPositions: 1,
        latitude: 11.5678,
        longitude: 104.8983,
        address:
            'No. 6, Street 1986, Sangkat Toul Sangke, Khan Russey Keo, Phnom Penh, Cambodia',
      ),
      CompanyModel(
        id: '7',
        name: 'foodpanda',
        logo: 'assets/images/foodpanda.png',
        industry: 'Food & Delivery',
        location: 'Phnom Penh, Cambodia',
        description:
            'foodpanda is Asia\'s leading online food and grocery delivery platform, operating in Cambodia and connecting customers with their favourite restaurants.',
        website: 'https://www.foodpanda.com.kh',
        openPositions: 4,
        latitude: 11.5620,
        longitude: 104.9210,
        address: 'Phnom Penh, Cambodia',
      ),
      CompanyModel(
        id: '8',
        name: 'Sathapana Bank',
        logo: 'assets/images/sathapana bank.png',
        industry: 'Banking & Finance',
        location: 'Phnom Penh, Cambodia',
        description:
            'Sathapana Bank Plc. is a leading commercial bank in Cambodia, providing a full range of banking services to individuals and businesses.',
        website: 'https://www.sathapana.com.kh',
        openPositions: 5,
        latitude: 11.5700,
        longitude: 104.9180,
        address:
            'No. 83, Norodom Blvd, Sangkat Tonle Bassac, Khan Chamkarmorn, Phnom Penh, Cambodia',
      ),
      CompanyModel(
        id: '9',
        name: 'Chipmong Bank',
        logo: 'assets/images/chipmong bank.png',
        industry: 'Banking & Finance',
        location: 'Phnom Penh, Cambodia',
        description:
            'Chipmong Bank is one of Cambodia\'s fastest growing commercial banks, offering modern banking solutions for individuals and enterprises.',
        website: 'https://www.chipmongbank.com',
        openPositions: 6,
        latitude: 11.5590,
        longitude: 104.9140,
        address:
            'No. 271, Ang Duong Street, Sangkat Wat Phnom, Khan Daun Penh, Phnom Penh, Cambodia',
      ),
    ];

    _jobs = [
      JobModel(
        id: '1',
        title: 'Senior Flutter Developer',
        companyName: 'Passapp',
        companyLogo: 'assets/images/Passapp.png',
        location: 'Phnom Penh',
        salary: '\$2,000 - \$3,000',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Senior',
        isUrgent: true,
        deadline: 'March 20, 2026',
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
        companyName: 'Passapp',
        companyLogo: 'assets/images/Passapp.png',
        location: 'Phnom Penh',
        salary: '\$1,500 - \$2,000',
        type: 'Full-time',
        category: 'Design',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'March 25, 2026',
        description:
            'Passapp is seeking talented UI/UX Designers to create amazing user experiences for our digital products.\n\nResponsibilities:\n• Create user-centered designs by understanding business requirements\n• Create user flows, wireframes, prototypes and mockups\n• Design UI elements and tools such as navigation menus, search boxes, tabs and widgets\n• Develop UI mockups and prototypes that clearly illustrate how sites function and look',
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
        id: '2b',
        title: 'UI/UX Designer',
        companyName: 'Passapp',
        companyLogo: 'assets/images/Passapp.png',
        location: 'Phnom Penh',
        salary: '\$1,500 - \$2,000',
        type: 'Full-time',
        category: 'Design',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'March 25, 2026',
        description:
            'Passapp is seeking talented UI/UX Designers to create amazing user experiences for our digital products.\n\nResponsibilities:\n• Create user-centered designs by understanding business requirements\n• Create user flows, wireframes, prototypes and mockups\n• Design UI elements and tools such as navigation menus, search boxes, tabs and widgets\n• Develop UI mockups and prototypes that clearly illustrate how sites function and look',
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
        id: '2c',
        title: 'UI/UX Designer',
        companyName: 'Passapp',
        companyLogo: 'assets/images/Passapp.png',
        location: 'Phnom Penh',
        salary: '\$1,500 - \$2,000',
        type: 'Full-time',
        category: 'Design',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'March 25, 2026',
        description:
            'Passapp is seeking talented UI/UX Designers to create amazing user experiences for our digital products.\n\nResponsibilities:\n• Create user-centered designs by understanding business requirements\n• Create user flows, wireframes, prototypes and mockups\n• Design UI elements and tools such as navigation menus, search boxes, tabs and widgets\n• Develop UI mockups and prototypes that clearly illustrate how sites function and look',
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
        id: '2d',
        title: 'UI/UX Designer',
        companyName: 'Passapp',
        companyLogo: 'assets/images/Passapp.png',
        location: 'Phnom Penh',
        salary: '\$1,500 - \$2,000',
        type: 'Full-time',
        category: 'Design',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'March 25, 2026',
        description:
            'Passapp is seeking talented UI/UX Designers to create amazing user experiences for our digital products.\n\nResponsibilities:\n• Create user-centered designs by understanding business requirements\n• Create user flows, wireframes, prototypes and mockups\n• Design UI elements and tools such as navigation menus, search boxes, tabs and widgets\n• Develop UI mockups and prototypes that clearly illustrate how sites function and look',
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
        companyName: 'Wing Bank',
        companyLogo: 'assets/images/Wing.png',
        location: 'Phnom Penh',
        salary: '\$1,800 - \$2,500',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Senior',
        isUrgent: true,
        deadline: 'March 18, 2026',
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
        category: 'Marketing',
        experienceLevel: 'Senior',
        deadline: 'April 1, 2026',
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
        title: 'iOS Developer',
        companyName: 'ABA Bank',
        companyLogo: 'assets/images/ABA Bank.png',
        location: 'Phnom Penh',
        salary: '\$1,800 - \$2,800',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'March 16, 2026',
        description:
            'ABA Bank is looking for iOS Developers to help build and maintain our mobile banking application.\n\nResponsibilities:\n• Develop mobile applications for iOS\n• Collaborate with the design team to implement UI/UX\n• Integrate with backend services and APIs\n• Optimize application performance',
        requirements: [
          '2+ years iOS development experience',
          'Experience with Swift and SwiftUI',
          'Knowledge of RESTful APIs',
          'Understanding of mobile security best practices',
          'Experience with banking/fintech is a plus',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '5b',
        title: 'iOS Developer',
        companyName: 'ABA Bank',
        companyLogo: 'assets/images/ABA Bank.png',
        location: 'Phnom Penh',
        salary: '\$1,800 - \$2,800',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'March 16, 2026',
        description:
            'ABA Bank is looking for iOS Developers to help build and maintain our mobile banking application.\n\nResponsibilities:\n• Develop mobile applications for iOS\n• Collaborate with the design team to implement UI/UX\n• Integrate with backend services and APIs\n• Optimize application performance',
        requirements: [
          '2+ years iOS development experience',
          'Experience with Swift and SwiftUI',
          'Knowledge of RESTful APIs',
          'Understanding of mobile security best practices',
          'Experience with banking/fintech is a plus',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '6',
        title: 'Data Scientist',
        companyName: 'Smart Axiata',
        companyLogo: 'assets/images/Smart .png',
        location: 'Phnom Penh',
        salary: '\$2,200 - \$3,500',
        type: 'Full-time',
        category: 'Data Science',
        experienceLevel: 'Senior',
        isUrgent: true,
        deadline: 'March 19, 2026',
        description:
            'Smart Axiata is seeking a Data Scientist to help us make data-driven decisions.\n\nResponsibilities:\n• Collect, process, and analyze large datasets\n• Build machine learning models\n• Create reports and dashboards\n• Identify trends and patterns in data\n• Present findings to stakeholders',
        requirements: [
          '3+ years data science experience',
          'Proficiency in SQL, Python, and R',
          'Experience with machine learning frameworks',
          'Experience with data visualization tools (Tableau, Power BI)',
          'Strong analytical and problem-solving skills',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '6b',
        title: 'Frontend Developer',
        companyName: 'Wing Bank',
        companyLogo: 'assets/images/Wing.png',
        location: 'Phnom Penh',
        salary: '\$1,600 - \$2,400',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'March 21, 2026',
        description:
            'Wing Bank is looking for Frontend Developers to build modern web applications.\n\nResponsibilities:\n• Build responsive web applications using React\n• Collaborate with designers and backend developers\n• Optimize application performance\n• Write clean, maintainable code',
        requirements: [
          '2+ years frontend development experience',
          'Strong knowledge of React and TypeScript',
          'Experience with modern CSS frameworks',
          'Understanding of web security best practices',
          'Experience with banking/fintech is a plus',
        ],
        postedDate: '2 days ago',
      ),
      JobModel(
        id: '6c',
        title: 'Product Manager',
        companyName: 'Cellcard',
        companyLogo: 'assets/images/Cellcard.png',
        location: 'Phnom Penh',
        salary: '\$2,500 - \$4,000',
        type: 'Full-time',
        category: 'Management',
        experienceLevel: 'Senior',
        isUrgent: true,
        deadline: 'March 22, 2026',
        description:
            'Cellcard is seeking an experienced Product Manager to lead our digital products.\n\nResponsibilities:\n• Define product vision and strategy\n• Manage product roadmap and backlog\n• Work with cross-functional teams\n• Analyze market trends and user feedback',
        requirements: [
          '4+ years product management experience',
          'Strong analytical and strategic thinking',
          'Experience with Agile methodologies',
          'Excellent communication skills',
          'Technical background is a plus',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '7',
        title: 'Project Manager',
        companyName: 'Passapp',
        companyLogo: 'assets/images/Passapp.png',
        location: 'Siem Reap',
        salary: '\$2,500 - \$4,000',
        type: 'Full-time',
        category: 'Management',
        experienceLevel: 'Senior',
        deadline: 'April 5, 2026',
        description:
            'We are looking for an experienced Project Manager to lead our development projects.\n\nResponsibilities:\n• Plan and manage project timelines and milestones\n• Coordinate with cross-functional teams\n• Track project progress and report to stakeholders\n• Manage project risks and issues',
        requirements: [
          '5+ years project management experience',
          'PMP or Scrum Master certification preferred',
          'Strong leadership and communication skills',
          'Experience with Agile/Scrum methodologies',
          'Technical background is a plus',
        ],
        postedDate: '6 days ago',
      ),
      JobModel(
        id: '9',
        title: 'iOS Developer',
        companyName: 'Beltei University',
        companyLogo: 'assets/images/Beltei university.png',
        location: 'Phnom Penh',
        salary: '\$1,800 - \$2,800',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'March 15, 2026',
        description:
            'Beltei University is looking for a talented iOS Developer to join our digital transformation team.\n\nResponsibilities:\n• Design and build advanced iOS applications using Swift and SwiftUI\n• Collaborate with UI/UX designers to implement engaging mobile experiences\n• Integrate RESTful APIs and third-party SDKs\n• Ensure performance, quality, and responsiveness of applications\n• Participate in code reviews and mentor junior developers',
        requirements: [
          '2+ years of iOS development experience',
          'Proficiency in Swift and SwiftUI / UIKit',
          'Experience with Xcode and Apple Developer tools',
          'Understanding of MVC/MVVM architecture patterns',
          'Familiarity with REST APIs and JSON parsing',
          'Published at least one app on the App Store is a plus',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '8',
        title: 'DevOps Engineer',
        companyName: 'foodpanda',
        companyLogo: 'assets/images/foodpanda.png',
        location: 'Phnom Penh',
        salary: '\$2,000 - \$3,200',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Senior',
        isUrgent: true,
        deadline: 'March 18, 2026',
        description:
            'foodpanda is looking for a DevOps Engineer to manage our cloud infrastructure.\n\nResponsibilities:\n• Manage AWS/GCP cloud infrastructure\n• Implement CI/CD pipelines\n• Monitor system performance and reliability\n• Automate deployment processes',
        requirements: [
          '3+ years DevOps experience',
          'Strong knowledge of AWS or GCP',
          'Experience with Docker and Kubernetes',
          'Proficiency in scripting (Python, Bash)',
          'Experience with monitoring tools',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '8b',
        title: 'QA Engineer',
        companyName: 'Chipmong Bank',
        companyLogo: 'assets/images/chipmong bank.png',
        location: 'Phnom Penh',
        salary: '\$1,400 - \$2,000',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'March 20, 2026',
        description:
            'Chipmong Bank is looking for a QA Engineer to ensure quality of our banking applications.\n\nResponsibilities:\n• Design and execute test plans\n• Perform manual and automated testing\n• Report and track bugs\n• Collaborate with development team',
        requirements: [
          '2+ years QA experience',
          'Experience with test automation tools',
          'Knowledge of mobile and web testing',
          'Strong attention to detail',
          'Experience with banking apps is a plus',
        ],
        postedDate: '2 days ago',
      ),
      JobModel(
        id: '10',
        title: 'HR Officer',
        companyName: 'ABA Bank',
        companyLogo: 'assets/images/ABA Bank.png',
        location: 'Phnom Penh',
        salary: '\$900 - \$1,400',
        type: 'Full-time',
        category: 'Management',
        experienceLevel: 'Mid',
        deadline: 'March 22, 2026',
        description:
            'ABA Bank is looking for an HR Officer to support our growing team.\n\nResponsibilities:\n• Manage recruitment and onboarding processes\n• Maintain employee records and HR databases\n• Support performance management and reviews\n• Handle employee relations and grievances\n• Coordinate training and development programs',
        requirements: [
          '2+ years HR experience',
          'Knowledge of Cambodian labor law',
          'Strong interpersonal and communication skills',
          'Proficiency in MS Office',
          'Bachelor degree in HR or related field',
        ],
        postedDate: 'Today',
      ),
      JobModel(
        id: '11',
        title: 'Junior Accountant',
        companyName: 'Wing Bank',
        companyLogo: 'assets/images/Wing.png',
        location: 'Phnom Penh',
        salary: '\$600 - \$900',
        type: 'Full-time',
        category: 'Finance',
        experienceLevel: 'Entry',
        deadline: 'March 31, 2026',
        description:
            'Wing Bank is seeking a Junior Accountant to join our finance department.\n\nResponsibilities:\n• Prepare and maintain financial records\n• Process invoices and payments\n• Assist with monthly and annual financial reports\n• Support internal and external audits\n• Reconcile bank statements',
        requirements: [
          'Bachelor degree in Accounting or Finance',
          'Knowledge of QuickBooks or MYOB',
          'Strong attention to detail',
          'Good analytical skills',
          'Fresh graduates are welcome to apply',
        ],
        postedDate: 'Today',
      ),
      JobModel(
        id: '12',
        title: 'Network Engineer',
        companyName: 'Cellcard',
        companyLogo: 'assets/images/Cellcard.png',
        location: 'Phnom Penh',
        salary: '\$1,400 - \$2,200',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'March 17, 2026',
        description:
            'Cellcard is looking for a Network Engineer to manage and optimize our telecom infrastructure.\n\nResponsibilities:\n• Configure and maintain network hardware and software\n• Monitor network performance and troubleshoot issues\n• Plan network expansions and upgrades\n• Ensure network security and compliance\n• Collaborate with vendors and partners',
        requirements: [
          '3+ years network engineering experience',
          'Cisco CCNA/CCNP certification preferred',
          'Experience with routers, switches, and firewalls',
          'Knowledge of TCP/IP and network protocols',
          'Experience in telecom industry is a plus',
        ],
        postedDate: 'Yesterday',
      ),
      JobModel(
        id: '13',
        title: 'Content Creator',
        companyName: 'Passapp',
        companyLogo: 'assets/images/Passapp.png',
        location: 'Phnom Penh',
        salary: '\$700 - \$1,100',
        type: 'Part-time',
        category: 'Marketing',
        experienceLevel: 'Entry',
        deadline: 'April 8, 2026',
        description:
            'Passapp is looking for a creative Content Creator to produce engaging digital content.\n\nResponsibilities:\n• Create written and visual content for social media\n• Write blog posts and marketing copy\n• Plan and execute content calendar\n• Engage with the online community\n• Analyze content performance metrics',
        requirements: [
          'Strong writing skills in Khmer and English',
          'Basic photo and video editing skills',
          'Familiarity with social media platforms',
          'Creative and self-motivated',
          'Portfolio of content work is a plus',
        ],
        postedDate: 'Yesterday',
      ),
      JobModel(
        id: '14',
        title: 'Customer Service Representative',
        companyName: 'Smart Axiata',
        companyLogo: 'assets/images/Smart .png',
        location: 'Phnom Penh',
        salary: '\$450 - \$700',
        type: 'Full-time',
        category: 'Management',
        experienceLevel: 'Entry',
        deadline: 'April 15, 2026',
        description:
            'Smart Axiata is hiring Customer Service Representatives to support our subscribers.\n\nResponsibilities:\n• Respond to customer inquiries via phone, email, and chat\n• Resolve customer complaints efficiently and professionally\n• Record customer interactions in the CRM system\n• Escalate complex issues to the relevant team\n• Meet customer satisfaction and resolution targets',
        requirements: [
          'Excellent communication skills in Khmer and English',
          'Patient and empathetic personality',
          'Basic computer skills',
          'Ability to work in shifts',
          'Fresh graduates are encouraged to apply',
        ],
        postedDate: '3 days ago',
      ),
      // ── foodpanda jobs ──
      JobModel(
        id: '15',
        title: 'Delivery Operations Manager',
        companyName: 'foodpanda',
        companyLogo: 'assets/images/foodpanda.png',
        location: 'Phnom Penh',
        salary: '\$1,500 - \$2,200',
        type: 'Full-time',
        category: 'Management',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'April 10, 2026',
        description:
            'foodpanda Cambodia is looking for a Delivery Operations Manager to oversee our rider fleet and ensure smooth last-mile delivery.\n\nResponsibilities:\n• Manage and coordinate the delivery rider team across Phnom Penh\n• Monitor delivery performance metrics and KPIs\n• Optimize delivery routes and reduce delivery time\n• Handle rider onboarding, training, and scheduling\n• Collaborate with restaurant partners to resolve delivery issues',
        requirements: [
          '3+ years operations or logistics management experience',
          'Strong leadership and team coordination skills',
          'Experience with logistics or delivery platforms is a plus',
          'Data-driven mindset with Excel/Google Sheets proficiency',
          'Good communication in Khmer and English',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '16',
        title: 'Digital Marketing Specialist',
        companyName: 'foodpanda',
        companyLogo: 'assets/images/foodpanda.png',
        location: 'Phnom Penh',
        salary: '\$900 - \$1,400',
        type: 'Full-time',
        category: 'Marketing',
        experienceLevel: 'Mid',
        deadline: 'April 20, 2026',
        description:
            'foodpanda is seeking a Digital Marketing Specialist to drive online campaigns and grow our user base in Cambodia.\n\nResponsibilities:\n• Plan and execute digital marketing campaigns (Facebook, TikTok, Google)\n• Manage social media channels and create engaging content\n• Analyse campaign performance and optimise for ROI\n• Coordinate with creative team on promotional materials\n• Track competitor marketing strategies',
        requirements: [
          '2+ years digital marketing experience',
          'Proficiency in Facebook Ads Manager and Google Ads',
          'Strong analytical skills using Google Analytics',
          'Creative copywriting skills in Khmer and English',
          'Experience in food-tech or e-commerce is a plus',
        ],
        postedDate: 'Today',
      ),
      // ── Sathapana Bank jobs ──
      JobModel(
        id: '17',
        title: 'Loan Officer',
        companyName: 'Sathapana Bank',
        companyLogo: 'assets/images/sathapana bank.png',
        location: 'Phnom Penh',
        salary: '\$700 - \$1,100',
        type: 'Full-time',
        category: 'Finance',
        experienceLevel: 'Entry',
        deadline: 'April 12, 2026',
        description:
            'Sathapana Bank is hiring Loan Officers to support our retail and SME lending operations.\n\nResponsibilities:\n• Evaluate loan applications and assess credit risk\n• Visit clients for field assessments and data verification\n• Prepare loan proposals and present to credit committee\n• Monitor loan repayments and manage overdue accounts\n• Build and maintain relationships with existing and potential borrowers',
        requirements: [
          'Bachelor degree in Finance, Banking, or related field',
          'Knowledge of credit analysis and banking products',
          'Good interpersonal and negotiation skills',
          'Willingness to travel for client visits',
          'Fresh graduates with finance background are welcome',
        ],
        postedDate: '2 days ago',
      ),
      JobModel(
        id: '18',
        title: 'IT Support Engineer',
        companyName: 'Sathapana Bank',
        companyLogo: 'assets/images/sathapana bank.png',
        location: 'Phnom Penh',
        salary: '\$800 - \$1,300',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Entry',
        isUrgent: true,
        deadline: 'April 5, 2026',
        description:
            'Sathapana Bank is looking for an IT Support Engineer to maintain our banking systems and provide technical support.\n\nResponsibilities:\n• Provide first and second-level IT support to bank staff\n• Install, configure, and maintain hardware and software\n• Troubleshoot network and system issues\n• Monitor and maintain bank servers and infrastructure\n• Assist in IT security and backup procedures',
        requirements: [
          'Bachelor degree in IT, Computer Science, or related field',
          'Knowledge of Windows Server, Active Directory, and networking',
          'Experience with banking core systems is a plus',
          'Strong problem-solving and communication skills',
          'Ability to work outside regular hours when needed',
        ],
        postedDate: 'Yesterday',
      ),
      // ── Chipmong Bank jobs ──
      JobModel(
        id: '19',
        title: 'Mobile Banking Developer',
        companyName: 'Chipmong Bank',
        companyLogo: 'assets/images/chipmong bank.png',
        location: 'Phnom Penh',
        salary: '\$1,600 - \$2,500',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Mid',
        isUrgent: true,
        deadline: 'April 8, 2026',
        description:
            'Chipmong Bank is looking for a Mobile Banking Developer to build and enhance our flagship mobile banking application.\n\nResponsibilities:\n• Develop and maintain the Chipmong mobile banking app (iOS & Android)\n• Implement new features including payments, transfers, and e-KYC\n• Collaborate with backend team to integrate secure APIs\n• Ensure app security, performance, and compliance with NBC regulations\n• Participate in UAT testing and production releases',
        requirements: [
          '2+ years mobile development with Flutter or React Native',
          'Understanding of mobile security and encryption',
          'Experience with RESTful APIs and JSON',
          'Knowledge of banking/fintech domain is a strong plus',
          'Ability to work in an Agile environment',
        ],
        postedDate: 'Today',
      ),
      JobModel(
        id: '20',
        title: 'Branch Manager',
        companyName: 'Chipmong Bank',
        companyLogo: 'assets/images/chipmong bank.png',
        location: 'Siem Reap',
        salary: '\$2,000 - \$3,000',
        type: 'Full-time',
        category: 'Management',
        experienceLevel: 'Senior',
        deadline: 'April 18, 2026',
        description:
            'Chipmong Bank is seeking an experienced Branch Manager to lead our Siem Reap branch operations.\n\nResponsibilities:\n• Oversee daily branch operations and staff management\n• Drive business development and meet branch targets\n• Ensure compliance with NBC regulations and bank policies\n• Build relationships with corporate and retail clients\n• Handle escalated customer issues and provide resolution',
        requirements: [
          '5+ years banking experience with 2+ years in management',
          'Strong leadership and people management skills',
          'Knowledge of NBC regulations and banking compliance',
          'Excellent communication in Khmer and English',
          'Bachelor degree in Business, Finance, or related field',
        ],
        postedDate: '3 days ago',
      ),
      // Additional Technology Jobs
      JobModel(
        id: '21',
        title: 'Full Stack Developer',
        companyName: 'Passapp',
        companyLogo: 'assets/images/Passapp.png',
        location: 'Phnom Penh',
        salary: '\$1,800 - \$2,800',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Mid',
        deadline: 'April 25, 2026',
        description:
            'Join Passapp as a Full Stack Developer to build innovative solutions.\n\nResponsibilities:\n• Develop and maintain web applications\n• Work with React and Node.js\n• Collaborate with design and product teams\n• Write clean, maintainable code',
        requirements: [
          '2+ years full stack development experience',
          'Proficiency in React and Node.js',
          'Experience with MongoDB or PostgreSQL',
          'Strong problem-solving skills',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '22',
        title: 'Graphic Designer',
        companyName: 'Cellcard',
        companyLogo: 'assets/images/Cellcard.png',
        location: 'Phnom Penh',
        salary: '\$800 - \$1,200',
        type: 'Full-time',
        category: 'Design',
        experienceLevel: 'Entry',
        deadline: 'April 20, 2026',
        description:
            'Cellcard is looking for a creative Graphic Designer to join our marketing team.\n\nResponsibilities:\n• Create visual content for campaigns\n• Design marketing materials\n• Collaborate with marketing team\n• Maintain brand consistency',
        requirements: [
          '1+ year graphic design experience',
          'Proficiency in Adobe Creative Suite',
          'Strong portfolio',
          'Creative thinking',
        ],
        postedDate: '2 days ago',
      ),
      JobModel(
        id: '23',
        title: 'Social Media Manager',
        companyName: 'foodpanda',
        companyLogo: 'assets/images/foodpanda.png',
        location: 'Phnom Penh',
        salary: '\$1,000 - \$1,600',
        type: 'Full-time',
        category: 'Marketing',
        experienceLevel: 'Mid',
        deadline: 'April 22, 2026',
        description:
            'foodpanda seeks a Social Media Manager to grow our online presence.\n\nResponsibilities:\n• Manage social media accounts\n• Create engaging content\n• Analyze social media metrics\n• Run social media campaigns',
        requirements: [
          '2+ years social media management',
          'Experience with Facebook, Instagram, TikTok',
          'Strong copywriting skills',
          'Data-driven mindset',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '24',
        title: 'Financial Analyst',
        companyName: 'ABA Bank',
        companyLogo: 'assets/images/ABA Bank.png',
        location: 'Phnom Penh',
        salary: '\$1,500 - \$2,200',
        type: 'Full-time',
        category: 'Finance',
        experienceLevel: 'Mid',
        deadline: 'April 28, 2026',
        description:
            'ABA Bank is hiring a Financial Analyst to support our finance team.\n\nResponsibilities:\n• Analyze financial data\n• Prepare financial reports\n• Support budgeting process\n• Provide financial insights',
        requirements: [
          '2+ years financial analysis experience',
          'Strong Excel skills',
          'Knowledge of financial modeling',
          'Bachelor degree in Finance or Accounting',
        ],
        postedDate: '3 days ago',
      ),
      JobModel(
        id: '25',
        title: 'Data Analyst',
        companyName: 'Smart Axiata',
        companyLogo: 'assets/images/Smart .png',
        location: 'Phnom Penh',
        salary: '\$1,400 - \$2,000',
        type: 'Full-time',
        category: 'Data Science',
        experienceLevel: 'Mid',
        deadline: 'April 30, 2026',
        description:
            'Smart Axiata needs a Data Analyst to help drive data-driven decisions.\n\nResponsibilities:\n• Analyze customer data\n• Create dashboards and reports\n• Identify trends and insights\n• Support business teams',
        requirements: [
          '2+ years data analysis experience',
          'Proficiency in SQL and Python',
          'Experience with Tableau or Power BI',
          'Strong analytical skills',
        ],
        postedDate: '2 days ago',
      ),
      JobModel(
        id: '26',
        title: 'Operations Manager',
        companyName: 'Wing Bank',
        companyLogo: 'assets/images/Wing.png',
        location: 'Phnom Penh',
        salary: '\$2,200 - \$3,200',
        type: 'Full-time',
        category: 'Management',
        experienceLevel: 'Senior',
        deadline: 'May 5, 2026',
        description:
            'Wing Bank seeks an Operations Manager to optimize our operations.\n\nResponsibilities:\n• Manage daily operations\n• Improve operational efficiency\n• Lead operations team\n• Implement process improvements',
        requirements: [
          '4+ years operations management experience',
          'Strong leadership skills',
          'Process improvement expertise',
          'Banking experience preferred',
        ],
        postedDate: '4 days ago',
      ),
      JobModel(
        id: '27',
        title: 'Android Developer',
        companyName: 'Passapp',
        companyLogo: 'assets/images/Passapp.png',
        location: 'Phnom Penh',
        salary: '\$1,600 - \$2,400',
        type: 'Full-time',
        category: 'Technology',
        experienceLevel: 'Mid',
        deadline: 'April 26, 2026',
        description:
            'Passapp is looking for an Android Developer to build mobile apps.\n\nResponsibilities:\n• Develop Android applications\n• Work with Kotlin and Java\n• Integrate APIs\n• Optimize app performance',
        requirements: [
          '2+ years Android development',
          'Strong knowledge of Kotlin',
          'Experience with Android SDK',
          'Published apps on Play Store',
        ],
        postedDate: '1 day ago',
      ),
      JobModel(
        id: '28',
        title: 'UX Researcher',
        companyName: 'ABA Bank',
        companyLogo: 'assets/images/ABA Bank.png',
        location: 'Phnom Penh',
        salary: '\$1,200 - \$1,800',
        type: 'Full-time',
        category: 'Design',
        experienceLevel: 'Mid',
        deadline: 'April 29, 2026',
        description:
            'ABA Bank needs a UX Researcher to improve user experience.\n\nResponsibilities:\n• Conduct user research\n• Analyze user behavior\n• Create user personas\n• Present research findings',
        requirements: [
          '2+ years UX research experience',
          'Experience with user testing',
          'Strong analytical skills',
          'Knowledge of research methodologies',
        ],
        postedDate: '2 days ago',
      ),
      JobModel(
        id: '29',
        title: 'Brand Manager',
        companyName: 'Cellcard',
        companyLogo: 'assets/images/Cellcard.png',
        location: 'Phnom Penh',
        salary: '\$1,800 - \$2,600',
        type: 'Full-time',
        category: 'Marketing',
        experienceLevel: 'Senior',
        deadline: 'May 1, 2026',
        description:
            'Cellcard is hiring a Brand Manager to lead our brand strategy.\n\nResponsibilities:\n• Develop brand strategy\n• Manage brand campaigns\n• Monitor brand performance\n• Collaborate with agencies',
        requirements: [
          '3+ years brand management experience',
          'Strong strategic thinking',
          'Experience in telecommunications preferred',
          'Excellent communication skills',
        ],
        postedDate: '3 days ago',
      ),
      JobModel(
        id: '30',
        title: 'Credit Officer',
        companyName: 'Sathapana Bank',
        companyLogo: 'assets/images/sathapana bank.png',
        location: 'Phnom Penh',
        salary: '\$900 - \$1,400',
        type: 'Full-time',
        category: 'Finance',
        experienceLevel: 'Entry',
        deadline: 'April 24, 2026',
        description:
            'Sathapana Bank is looking for a Credit Officer to assess loan applications.\n\nResponsibilities:\n• Evaluate loan applications\n• Assess credit risk\n• Prepare credit reports\n• Monitor loan portfolio',
        requirements: [
          '1+ year banking or finance experience',
          'Knowledge of credit analysis',
          'Strong attention to detail',
          'Good communication skills',
        ],
        postedDate: '2 days ago',
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

  void applyJob(String jobId) {
    if (_jobs.isEmpty) return;
    final job = _jobs.firstWhere(
      (j) => j.id == jobId,
      orElse: () => _jobs.first,
    );
    if (!_appliedJobs.any((j) => j.id == jobId)) {
      _appliedJobs.insert(0, job);

      // Create application status tracking
      _applicationStatuses[jobId] = ApplicationStatus(
        jobId: jobId,
        status: ApplicationStatusType.applied,
        appliedDate: DateTime.now(),
      );

      notifyListeners();
    }
  }

  // Update application status
  void updateApplicationStatus(
    String jobId,
    ApplicationStatusType newStatus, {
    String? message,
  }) {
    if (_applicationStatuses.containsKey(jobId)) {
      final current = _applicationStatuses[jobId]!;
      final newTimeline = List<StatusUpdate>.from(current.timeline);
      newTimeline.add(
        StatusUpdate(
          status: newStatus,
          date: DateTime.now(),
          message: message ?? _getDefaultStatusMessage(newStatus),
        ),
      );

      _applicationStatuses[jobId] = current.copyWith(
        status: newStatus,
        lastUpdated: DateTime.now(),
        timeline: newTimeline,
      );
      notifyListeners();
    }
  }

  String _getDefaultStatusMessage(ApplicationStatusType status) {
    switch (status) {
      case ApplicationStatusType.applied:
        return 'Application submitted';
      case ApplicationStatusType.reviewing:
        return 'Application is being reviewed by employer';
      case ApplicationStatusType.interview:
        return 'Interview has been scheduled';
      case ApplicationStatusType.rejected:
        return 'Application was not successful this time';
      case ApplicationStatusType.accepted:
        return 'Congratulations! You received a job offer';
    }
  }

  ApplicationStatus? getApplicationStatus(String jobId) {
    return _applicationStatuses[jobId];
  }

  bool hasApplied(String jobId) {
    return _applicationStatuses.containsKey(jobId);
  }

  // ── Compare jobs ──
  bool isInCompare(String jobId) => _compareList.any((j) => j.id == jobId);

  void toggleCompare(String jobId) {
    final idx = _compareList.indexWhere((j) => j.id == jobId);
    if (idx != -1) {
      _compareList.removeAt(idx);
    } else if (_compareList.length < 3) {
      final job = getJobById(jobId);
      if (job != null) _compareList.add(job);
    }
    notifyListeners();
  }

  // ── Job Alerts ──
  void addJobAlert(Map<String, String> alert) {
    _jobAlerts.insert(0, {
      ...alert,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    notifyListeners();
  }

  void removeJobAlert(String id) {
    _jobAlerts.removeWhere((a) => a['id'] == id);
    notifyListeners();
  }

  List<JobModel> getRecommendedJobs(List<String> preferredCategories) {
    if (preferredCategories.isEmpty) return _jobs.take(5).toList();
    final matches = _jobs
        .where((j) => preferredCategories.contains(j.category))
        .toList();
    if (matches.length >= 5) return matches.take(5).toList();
    final others = _jobs
        .where((j) => !preferredCategories.contains(j.category))
        .toList();
    return [...matches, ...others].take(5).toList();
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

  List<String> get locations => _jobs.map((j) => j.location).toSet().toList();

  List<String> get categories => [
    'Technology',
    'Design',
    'Marketing',
    'Finance',
    'Management',
    'Data Science',
  ];

  static const List<String> jobTypes = [
    'Full-time',
    'Part-time',
    'Remote',
    'Internship',
  ];

  static const List<String> experienceLevels = ['Entry', 'Mid', 'Senior'];

  static const List<String> sortOptions = [
    'Newest',
    'Salary High-Low',
    'Salary Low-High',
  ];
}
