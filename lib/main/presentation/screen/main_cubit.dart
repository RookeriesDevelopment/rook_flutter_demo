import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:rook_flutter_demo/core/domain/extension/future_extensions.dart';
import 'package:rook_flutter_demo/core/domain/repository/auth_repository.dart';
import 'package:rook_flutter_demo/main/domain/model/main_state.dart';
import 'package:rook_flutter_demo/rook/repository/rook_health_repository.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';

class MainCubit extends Cubit<MainState> {
  final Logger _logger;
  final AuthRepository _authRepository;

  MainCubit({required Logger logger, required AuthRepository authRepository})
    : _authRepository = authRepository,
      _logger = logger,
      super(MainState.unknown()) {
    init();
  }

  Future<void> init() async {
    emit(MainState.unknown());

    await _initSDKs().catchError((error) {
      _logger.e("Error initializing SDKs", error: error);
    });
    await _initUsersIfNecessary().catchError((error) {
      _logger.e("Error initializing Users", error: error);
    });
  }

  Future<void> _initSDKs() async {
    await dotenv.load();
    final clientUUID = dotenv.env['clientUUID'];
    final packageName = dotenv.env['packageName'];
    final bundleId = dotenv.env['bundleId'];
    final secret = dotenv.env['secret'];
    final environment = RookEnvironment.sandbox;

    if (clientUUID == null || packageName == null || bundleId == null || secret == null) {
      _logger.e("Missing clientUUID, packageName, bundleId or secret");
      return;
    }

    if (kDebugMode) {
      await RookHealthRepository.enableNativeLogs();
    }

    await RookHealthRepository.initRook(
      clientUUID,
      secret,
      environment,
      packageName,
      bundleId,
    ).then((value) {
      _logger.i("Rook SDKs initialized");
    });
  }

  Future<void> _initUsersIfNecessary() async {
    final userID = await _authRepository.getUserID();

    if (userID == null) {
      emit(MainState.unauthenticated());
      return;
    }

    final rookUserID = await RookHealthRepository.getUserID();

    final isUserCorrect = userID == rookUserID;

    // Edge case where the ids are not the same
    if (!isUserCorrect) {
      await RookHealthRepository.updateUserID(userID).fold(
        (value) async {
          _logger.i("All Users updated");
        },
        (error) async {
          _logger.e("Error updating Users", error: error);
        },
      );
      ;
    }

    emit(MainState.authenticated());
  }
}
