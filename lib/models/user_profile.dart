class UserProfile {
  final String name;
  final int age;
  final String profilePhotoUrl;
  final String email;
  final String phone;
  final String address;

  UserProfile({
    required this.name,
    required this.age,
    required this.profilePhotoUrl,
    this.email = '',
    this.phone = '',
    this.address = '',
  });
}
