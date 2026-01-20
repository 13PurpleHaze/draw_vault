import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/*
  Класс для работы с подулючением. Просто предоставляет стрим, на который подписывается тот кому нужно
*/
@Singleton()
class ConnectivityService {
  final _controller = StreamController<bool>.broadcast();

  // Стрим для прослушки подключения
  Stream<bool> get connectivityStream => _controller.stream;

  ConnectivityService() {
    InternetConnection().onStatusChange.listen((InternetStatus status) {
      _controller.add(InternetStatus.connected == status);
    });
  }

  void dispose() {
    _controller.close();
  }
}
