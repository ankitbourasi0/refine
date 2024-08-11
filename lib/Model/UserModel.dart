class UserModel {
  final String name;
  final int age;
  final String location;

  UserModel({required this.name, required this.age, required this.location});

  Map<String, dynamic> toJson() =>
      {'name': name, 'age': age, 'location': location};

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'],
        age: json['age'],
        location: json['location'],
      );
}
