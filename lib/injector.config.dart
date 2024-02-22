// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:calendar_scheduler_mobile/app/domain/repositories/auth_repository.dart'
    as _i3;
import 'package:calendar_scheduler_mobile/app/domain/repositories/meeting_repository.dart'
    as _i6;
import 'package:calendar_scheduler_mobile/app/infra/dio/app_dio_options.dart'
    as _i8;
import 'package:calendar_scheduler_mobile/app/infra/repositories/auth_repository_impl.dart'
    as _i4;
import 'package:calendar_scheduler_mobile/app/infra/repositories/meeting_repository_impl.dart'
    as _i7;
import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioProvider = _$DioProvider();
    gh.factory<_i3.AuthRepository>(() => _i4.AuthRepositoryImpl());
    gh.singleton<_i5.Dio>(dioProvider.dio());
    gh.factory<_i6.MeetingRepository>(
        () => _i7.MeetingRepositoryImpl(gh<_i5.Dio>()));
    return this;
  }
}

class _$DioProvider extends _i8.DioProvider {}
