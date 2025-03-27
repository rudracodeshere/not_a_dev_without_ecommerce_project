class User {
  String? firstName;
  String? lastName;
  int? gender;
  String? age;
  String? email;

  User({this.firstName, this.lastName, this.gender, this.age, this.email});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    age = json['age'];
    email = json['email'];
  }

}
