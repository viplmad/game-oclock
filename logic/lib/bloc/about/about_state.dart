import 'package:equatable/equatable.dart';

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
  const AboutNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'AboutNotLoaded { '
      'error: $error'
      ' }';
}
