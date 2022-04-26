// ignore: unused_import
import 'package:meta/meta.dart';

class RegisterState {
  
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isNameValid;
  final bool isSurnameValid;
  final bool isPhoneValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isEmailDuplicate;

  bool get isFormValid =>
    isEmailValid &&
    isPasswordValid &&
    isNameValid &&
    isSurnameValid &&
    isPhoneValid;

  RegisterState(
    {
      required this.isEmailValid,
      required this.isPasswordValid,
      required this.isNameValid,
      required this.isSurnameValid,
      required this.isPhoneValid,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isFailure,
      required this.isEmailDuplicate
    }
  );

  factory RegisterState.empty() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isNameValid: true,
      isSurnameValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isEmailDuplicate: false
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isNameValid: true,
      isSurnameValid: true,
      isPhoneValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      isEmailDuplicate: false
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isNameValid: true,
      isSurnameValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      isEmailDuplicate: false
    );
  }

  factory RegisterState.duplicate() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isNameValid: true,
      isSurnameValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isEmailDuplicate: true
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isNameValid: true,
      isSurnameValid: true,
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      isEmailDuplicate: false
    );
  }


  RegisterState update(
    {
      bool? isEmailValid,
      bool? isPasswordValid,
      bool? isNameValid,
      bool? isSurnameValid,
      bool? isPhoneValid,
    }) {
    return copyWith(
        isEmailValid: isEmailValid ?? this.isEmailValid ,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isNameValid: isNameValid ?? this.isNameValid,
        isSurnameValid: isSurnameValid ?? this.isSurnameValid,
        isPhoneValid: isPhoneValid ?? this.isPhoneValid,
        isSubmitting: false,
        isSucess: false,
        isFailure: false,
        isEmailDuplicate: false
       );
  }

  RegisterState copyWith(
    {
      bool? isEmailValid,
      bool? isPasswordValid,
      bool? isNameValid,
      bool? isSurnameValid,
      bool? isPhoneValid,
      bool? isRolValid,
      bool? isSubmitting,
      bool? isSucess,
      bool? isFailure,
      bool? isEmailDuplicate
    }) {
    return RegisterState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isNameValid: isNameValid ?? this.isNameValid,
      isSurnameValid: isSurnameValid ?? this.isSurnameValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSucess ?? isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isEmailDuplicate: isEmailDuplicate ?? this.isEmailDuplicate
    );
  }

  @override
  String toString() {
    return ''' RegisterState{
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isNameValid: $isNameValid,
      isSurnameValid: $isSurnameValid,
      isPhoneValid: $isPhoneValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isEmailDuplicate: $isEmailDuplicate
    }
    ''';
  }
}