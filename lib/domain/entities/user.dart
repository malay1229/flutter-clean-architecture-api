// PURE Dart entity.
// No Flutter imports.
// No JSON logic.

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String companyName;
  final String address;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.companyName,
    required this.address,
  });
}