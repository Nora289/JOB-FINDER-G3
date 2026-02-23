class JobModel {
  final String id;
  final String title;
  final String companyName;
  final String companyLogo;
  final String location;
  final String salary;
  final String type;
  final String description;
  final List<String> requirements;
  final String postedDate;
  final bool isSaved;

  JobModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.companyLogo,
    required this.location,
    required this.salary,
    required this.type,
    required this.description,
    required this.requirements,
    required this.postedDate,
    this.isSaved = false,
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
      description: description,
      requirements: requirements,
      postedDate: postedDate,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
