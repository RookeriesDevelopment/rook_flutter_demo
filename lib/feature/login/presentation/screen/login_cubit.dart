import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:rook_flutter_demo/core/domain/repository/auth_repository.dart';
import 'package:rook_flutter_demo/feature/login/domain/enum/login_error.dart';
import 'package:rook_flutter_demo/feature/login/domain/model/login_state.dart';
import 'package:rook_flutter_demo/rook/repository/rook_health_repository.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';

class LoginCubit extends Cubit<LoginState> {
  final Logger _logger;
  final AuthRepository _authRepository;

  LoginCubit({required Logger logger, required AuthRepository authRepository})
    : _authRepository = authRepository,
      _logger = logger,
      super(LoginState());

  void onNextClick(String userID) {
    onLogin(userID.trim());
  }

  Future<void> onLogin(String userID) async {
    emit(state.copyWith(loading: true, error: null));

    await dotenv.load();
    final clientUUID = dotenv.env['clientUUID'];
    final secretKey = dotenv.env['secretKey'];
    final environment = RookEnvironment.sandbox;

    if (clientUUID == null || secretKey == null) {
      return;
    }

    final configuration = RookConfiguration(
      clientUUID: clientUUID,
      secretKey: secretKey,
      environment: environment,
      enableBackgroundSync: false,
    );

    try {
      if (kDebugMode) {
        await RookHealthRepository.enableNativeLogs();
      }

      await RookHealthRepository.initRook(configuration);
      await RookHealthRepository.updateUserID(userID);
      await _authRepository.login(userID);

      emit(state.copyWith(loading: false, loggedIn: true));
    } catch (error) {
      emit(state.copyWith(loading: false, error: LoginError.custom("$error")));
    }
  }
}
