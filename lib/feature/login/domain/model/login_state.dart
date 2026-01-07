import 'package:equatable/equatable.dart';
import 'package:rook_flutter_demo/feature/login/domain/enum/login_error.dart';

// TODO: Make error non nullable
class LoginState extends Equatable {
  final bool loading;
  final bool loggedIn;
  final LoginError? error;

  const LoginState({this.loading = false, this.loggedIn = false, this.error});

  LoginState copyWith({bool? loading, bool? loggedIn, LoginError? error}) {
    return LoginState(
      loading: loading ?? this.loading,
      loggedIn: loggedIn ?? this.loggedIn,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [loading, loggedIn, error];
}
