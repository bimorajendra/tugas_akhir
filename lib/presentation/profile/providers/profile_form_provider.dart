import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizilens/domain/models/user_profile.dart';

class ProfileFormState {
  final String age;
  final String? ageError;
  final Gender gender;
  final String height;
  final String? heightError;
  final String weight;
  final String? weightError;
  final bool isSubmitting;
  final bool isSuccess;

  const ProfileFormState({this.age = '', this.ageError, this.gender = Gender.male, this.height = '', this.heightError, this.weight = '', this.weightError, this.isSubmitting = false, this.isSuccess = false});

  ProfileFormState copyWith({String? age, String? ageError, bool clearAgeError = false, Gender? gender, String? height, String? heightError, bool clearHeightError = false, String? weight, String? weightError, bool clearWeightError = false, bool? isSubmitting, bool? isSuccess}) => ProfileFormState(
        age: age ?? this.age, ageError: clearAgeError ? null : (ageError ?? this.ageError), gender: gender ?? this.gender,
        height: height ?? this.height, heightError: clearHeightError ? null : (heightError ?? this.heightError),
        weight: weight ?? this.weight, weightError: clearWeightError ? null : (weightError ?? this.weightError),
        isSubmitting: isSubmitting ?? this.isSubmitting, isSuccess: isSuccess ?? this.isSuccess,
      );
}

class ProfileFormNotifier extends StateNotifier<ProfileFormState> {
  ProfileFormNotifier() : super(const ProfileFormState());
  void setAge(String value) => state = state.copyWith(age: value, clearAgeError: true);
  void setGender(Gender value) => state = state.copyWith(gender: value);
  void setHeight(String value) => state = state.copyWith(height: value, clearHeightError: true);
  void setWeight(String value) => state = state.copyWith(weight: value, clearWeightError: true);

  bool validate() {
    String? ageError;
    String? heightError;
    String? weightError;
    final age = int.tryParse(state.age);
    final height = double.tryParse(state.height);
    final weight = double.tryParse(state.weight);
    if (state.age.trim().isEmpty) {
      ageError = 'Bagian ini wajib diisi.';
    } else if (age == null || age <= 0 || age > 120) {
      ageError = 'Masukkan usia yang valid.';
    }
    if (state.height.trim().isEmpty) {
      heightError = 'Bagian ini wajib diisi.';
    } else if (height == null || height <= 40 || height > 250) {
      heightError = 'Masukkan tinggi badan yang valid.';
    }
    if (state.weight.trim().isEmpty) {
      weightError = 'Bagian ini wajib diisi.';
    } else if (weight == null || weight <= 10 || weight > 300) {
      weightError = 'Masukkan berat badan yang valid.';
    }
    state = state.copyWith(ageError: ageError, clearAgeError: ageError == null, heightError: heightError, clearHeightError: heightError == null, weightError: weightError, clearWeightError: weightError == null);
    return ageError == null && heightError == null && weightError == null;
  }

  Future<void> submit() async {
    if (!validate()) return;
    state = state.copyWith(isSubmitting: true);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    state = state.copyWith(isSubmitting: false, isSuccess: true);
  }
}

final profileFormProvider = StateNotifierProvider<ProfileFormNotifier, ProfileFormState>((ref) => ProfileFormNotifier());
