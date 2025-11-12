import 'dart:io';

import 'package:rook_sdk_apple_health/rook_sdk_apple_health.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';
import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';

class RookApiHealthRepository {
  RookApiHealthRepository._();

  static Future<DataSourceAuthorizer> getDataSourceAuthorizer(
    String dataSource,
    String redirectUrl,
  ) {
    if (Platform.isIOS) {
      return AHRookDataSources.getDataSourceAuthorizer(
        dataSource,
        redirectUrl: redirectUrl,
      );
    } else {
      return HCRookDataSources.getDataSourceAuthorizer(
        dataSource,
        redirectUrl: redirectUrl,
      );
    }
  }

  static Future<List<AuthorizedDataSourceV2>> getAuthorizedDataSourcesV2() {
    if (Platform.isIOS) {
      return AHRookDataSources.getAuthorizedDataSourcesV2();
    } else {
      return HCRookDataSources.getAuthorizedDataSourcesV2();
    }
  }

  static Future<void> revokeDataSource(String dataSource) {
    if (Platform.isIOS) {
      return AHRookDataSources.revokeDataSource(dataSource);
    } else {
      return HCRookDataSources.revokeDataSource(dataSource);
    }
  }
}
