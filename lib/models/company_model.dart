class CompanyModel {
  final String id;
  final String name;
  final String logo;
  final String industry;
  final String location;
  final String description;
  final String website;
  final int openPositions;
  final double latitude;
  final double longitude;
  final String address;

  CompanyModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.industry,
    required this.location,
    required this.description,
    required this.website,
    required this.openPositions,
    this.latitude = 11.5564,
    this.longitude = 104.9282,
    this.address = 'Phnom Penh, Cambodia',
  });
}
