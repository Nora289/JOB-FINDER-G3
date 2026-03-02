class JobModel {
  final String id;
  final String title;
  final String companyName;
  final String companyLogo;
  final String location;
  final String salary;
  final String type; // Full-time, Part-time, Remote, Internship
  final String category; // Technology, Design, Marketing, Finance, etc.
  final String experienceLevel; // Entry, Mid, Senior
  final String description;
  final List<String> requirements;
  final String postedDate;
  final String? deadline;
  final bool isSaved;
  final bool isUrgent;

  JobModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.companyLogo,
    required this.location,
    required this.salary,
    required this.type,
    this.category = 'Technology',
    this.experienceLevel = 'Mid',
    required this.description,
    required this.requirements,
    required this.postedDate,
    this.deadline,
    this.isSaved = false,
    this.isUrgent = false,
  });

  JobModel copyWith({bool? isSaved}) {
    return JobModel(
      id: id,
      title: title,
      companyName: companyName,
      companyLogo: companyLogo,
      location: location,
      salary: salary,
      type: type,
      category: category,
      experienceLevel: experienceLevel,
      description: description,
      requirements: requirements,
      postedDate: postedDate,
      deadline: deadline,
      isSaved: isSaved ?? this.isSaved,
      isUrgent: isUrgent,
    );
  }
}
