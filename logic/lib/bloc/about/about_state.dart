import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

import 'package:package_info_plus/package_info_plus.dart';

abstract class AboutState extends Equatable {
  const AboutState();

  @override
  List<Object> get props => <Object>[];
}

class AboutLoading extends AboutState {}

class AboutLoaded extends AboutState {
  const AboutLoaded(this.packageInfo);

  final PackageInfo packageInfo;

  @override
  List<Object> get props => <Object>[
        packageInfo,
      ];

  @override
  String toString() => 'AboutLoaded { '
      'packageInfo: $packageInfo'
      ' }';
}

class AboutNotLoaded extends AboutState {
  const AboutNotLoaded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'AboutNotLoaded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
