import 'package:equatable/equatable.dart';
import 'package:rook_flutter_demo/main/domain/enum/AuthenticationStatus.dart';

class MainState extends Equatable {
  final AuthenticationStatus authenticationStatus;

  const MainState._({required this.authenticationStatus});

  const MainState.unknown()
    : this._(authenticationStatus: AuthenticationStatus.unknown);

  const MainState.authenticated()
    : this._(authenticationStatus: AuthenticationStatus.authenticated);

  const MainState.unauthenticated()
    : this._(authenticationStatus: AuthenticationStatus.unauthenticated);

  @override
  List<Object> get props => [authenticationStatus];
}
