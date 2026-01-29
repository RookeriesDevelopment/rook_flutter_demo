import 'package:equatable/equatable.dart';
import 'package:rook_flutter_demo/feature/settings/domain/enum/logout_status.dart';

final class SettingsState extends Equatable {
  final bool loggingOut;
  final LogoutStatus logoutStatus;

  const SettingsState({this.loggingOut = false, this.logoutStatus = LogoutStatus.unknown});

  SettingsState copyWith({bool? loggingOut, LogoutStatus? logoutStatus}) {
    return SettingsState(
      loggingOut: loggingOut ?? this.loggingOut,
      logoutStatus: logoutStatus ?? this.logoutStatus,
    );
  }

  @override
  List<Object?> get props => [loggingOut, logoutStatus];
}
