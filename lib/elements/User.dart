class User {
  final int index;
  final String name;
  final String picture;
  final int priority;

  User(this.index, this.name, this.picture, this.priority);
}

class UserProfile {
  final String id;
  final String first_name;
  final String last_name;
  final int user_type;
  final int gender;
  final DateTime date_joined;
  final DateTime date_of_birth;
  final String phone;
  final String email;
  UserProfile(
      this.id,
      this.first_name,
      this.last_name,
      this.user_type,
      this.gender,
      this.date_joined,
      this.date_of_birth,
      this.phone,
      this.email);
}

class Facility {
  final int id;
  final Facility facility;

  Facility(this.id, this.facility);
}
