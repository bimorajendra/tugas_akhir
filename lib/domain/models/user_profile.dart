enum Gender { male, female }

class UserProfile {
  final int age;
  final Gender gender;
  final double height;
  final double weight;

  const UserProfile({required this.age, required this.gender, required this.height, required this.weight});

  UserProfile copyWith({int? age, Gender? gender, double? height, double? weight}) => UserProfile(
        age: age ?? this.age,
        gender: gender ?? this.gender,
        height: height ?? this.height,
        weight: weight ?? this.weight,
      );
}
