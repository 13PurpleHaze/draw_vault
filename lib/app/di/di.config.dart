// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:draw_vault/app/navigation/app_router.dart' as _i158;
import 'package:draw_vault/app/navigation/guard.dart' as _i881;
import 'package:draw_vault/app/network/connectivly_service.dart' as _i912;
import 'package:draw_vault/app/notifications/notification_service.dart'
    as _i670;
import 'package:draw_vault/app/shared/data/repositories/app_picture_repository.dart'
    as _i211;
import 'package:draw_vault/app/shared/data/repositories/firebase_picture_repository.dart'
    as _i1054;
import 'package:draw_vault/app/shared/data/repositories/gallery_picture_repository.dart'
    as _i345;
import 'package:draw_vault/app/shared/domain/domain.dart' as _i401;
import 'package:draw_vault/app/shared/shared.dart' as _i96;
import 'package:draw_vault/features/auth/data/repositories/firebase_auth_repository.dart'
    as _i552;
import 'package:draw_vault/features/auth/domain/domain.dart' as _i1055;
import 'package:draw_vault/features/auth/presentation/bloc/auth_bloc.dart'
    as _i751;
import 'package:draw_vault/features/picture_drawing/presentation/bloc/picture_drawing_bloc.dart'
    as _i982;
import 'package:draw_vault/features/picture_list/presentation/bloc/picture_list_bloc.dart'
    as _i144;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i912.ConnectivityService>(() => _i912.ConnectivityService());
    gh.singleton<_i670.NotificationService>(() => _i670.NotificationService());
    gh.singleton<_i1054.FirebasePictureRepository>(
      () => _i1054.FirebasePictureRepository(),
    );
    gh.singleton<_i345.GalleryPictureRepository>(
      () => _i345.GalleryPictureRepository(),
    );
    gh.factory<_i1055.AuthRepository>(() => _i552.FirebaseAuthRepository());
    gh.factory<_i401.PictureRepository>(
      () => _i211.AppPictureRepository(
        galleryPictureRepository: gh<_i345.GalleryPictureRepository>(),
        firebasePictureRepository: gh<_i1054.FirebasePictureRepository>(),
      ),
    );
    gh.factory<_i982.PictureDrawingBloc>(
      () => _i982.PictureDrawingBloc(
        pictureRepository: gh<_i401.PictureRepository>(),
        notificationService: gh<_i670.NotificationService>(),
      ),
    );
    gh.singleton<_i751.AuthBloc>(
      () => _i751.AuthBloc(authRepository: gh<_i1055.AuthRepository>()),
    );
    gh.singleton<_i144.PictureListBloc>(
      () => _i144.PictureListBloc(
        pictureRepository: gh<_i96.PictureRepository>(),
        connectivityService: gh<_i912.ConnectivityService>(),
      ),
    );
    gh.singleton<_i881.AuthGuard>(
      () => _i881.AuthGuard(
        authRepo: gh<_i1055.AuthRepository>(),
        authBloc: gh<_i751.AuthBloc>(),
      ),
    );
    gh.singleton<_i158.AppRouter>(() => _i158.AppRouter(gh<_i881.AuthGuard>()));
    return this;
  }
}
