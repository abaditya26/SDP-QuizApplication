class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String image;
  final bool isAdmin;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.phone,
      required this.image,
      required this.isAdmin});
}
