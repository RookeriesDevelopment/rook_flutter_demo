import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rook_flutter_demo/core/domain/repository/auth_repository.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';

class RookApiHealthRepository {
  final AuthRepository _authRepository;
  RookApiSources? _apiSources;

  RookApiHealthRepository({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<RookApiSources> getOrCreateApiSources() async {
    if (_apiSources == null) {
      await dotenv.load();
      final clientUUID = dotenv.env['clientUUID'];
      final packageName = dotenv.env['packageName'];
      final secret = dotenv.env['secret'];
      final environment = RookEnvironment.sandbox;

      if (clientUUID == null || packageName == null || secret == null) {
        throw Exception("Missing clientUUID, packageName or secret");
      }

      _apiSources = RookApiSources(
        clientUUID: clientUUID,
        secret: secret,
        appId: packageName,
        environment: environment,
        enableLogs: kDebugMode,
      );
    }

    return _apiSources!;
  }

  Future<DataSourceAuthorizer> getDataSourceAuthorizer(
    String dataSource,
    String redirectUrl,
  ) async {
    final userID = await _authRepository.getUserID();

    if (userID == null) {
      throw Exception("User ID is null");
    }

    return (await getOrCreateApiSources()).getDataSourceAuthorizer(
      userID: userID,
      dataSource: dataSource,
      redirectUrl: redirectUrl,
    );
  }

  Future<List<AuthorizedDataSourceV2>> getAuthorizedDataSourcesV2() async {
    final userID = await _authRepository.getUserID();

    if (userID == null) {
      throw Exception("User ID is null");
    }

    return (await getOrCreateApiSources()).getAuthorizedDataSourcesV2(userID: userID);
  }

  Future<void> revokeDataSource(DataSourceType dataSource) async {
    final userID = await _authRepository.getUserID();

    if (userID == null) {
      throw Exception("User ID is null");
    }

    return (await getOrCreateApiSources()).revokeDataSource(userID: userID, dataSource: dataSource);
  }
}
