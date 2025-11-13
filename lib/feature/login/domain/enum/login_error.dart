import 'package:equatable/equatable.dart';

class LoginError extends Equatable {
  final LoginErrorType type;
  final String? message;

  String get messageOrDefault => message ?? "There was an error, try again";

  const LoginError._({required this.type, required this.message});

  const LoginError.userInvalid()
    : this._(type: LoginErrorType.userInvalid, message: null);

  const LoginError.custom(String message)
    : this._(type: LoginErrorType.custom, message: message);

  @override
  List<Object?> get props => [type, message];
}

enum LoginErrorType { userInvalid, custom }
