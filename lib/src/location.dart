import 'package:flutter/services.dart';

import 'position.dart';

enum LocationPermission { denied, deniedForever, whileInUse, always }

class WearLocation {
  static WearLocation instance = WearLocation();
  static const _channel = MethodChannel('org.oroncanopy.wear_location');
  static const _events = EventChannel('org.oroncanopy.wear_location/positions');
  static Stream<Position>? _positions;

  Future<bool> isLocationServiceEnabled() async =>
      await _channel.invokeMethod<bool>('serviceEnabled') ?? false;
  Future<bool> isPreciseLocationEnabled() async =>
      await _channel.invokeMethod<bool>('preciseEnabled') ?? false;
  Future<LocationPermission> checkPermission() => _permission('permission');
  Future<LocationPermission> requestPermission() =>
      _permission('requestPermission');
  Future<LocationPermission> requestBackgroundPermission() =>
      _permission('requestBackgroundPermission');
  Future<LocationPermission> _permission(String method) async =>
      LocationPermission.values[await _channel.invokeMethod<int>(method) ?? 0];
  Future<void> openLocationSettings() =>
      _channel.invokeMethod<void>('openLocationSettings');
  Future<void> openSettings() => _channel.invokeMethod<void>('openSettings');

  Future<Position> getCurrentPosition({
    Duration timeout = const Duration(seconds: 30),
    Duration maximumAge = Duration.zero,
  }) async {
    final result = await _channel.invokeMapMethod<Object?, Object?>('current', {
      'timeoutMs': timeout.inMilliseconds,
      'maximumAgeMs': maximumAge.inMilliseconds,
    });
    if (result == null) throw PlatformException(code: 'NO_FIX');
    return Position.fromMap(result);
  }

  Future<void> cancelCurrentPosition() =>
      _channel.invokeMethod<void>('cancelCurrent');

  /// 宿主串行调用启停，共享会话在最后一个使用方退出时停止
  Future<void> startUpdates({
    required String notificationTitle,
    required String notificationText,
    required String channelName,
    String? recoveryTitle,
    String? recoveryText,
  }) => _channel.invokeMethod<void>('start', {
    'notificationTitle': notificationTitle,
    'notificationText': notificationText,
    'channelName': channelName,
    'recoveryTitle': recoveryTitle,
    'recoveryText': recoveryText,
  });
  Future<void> stopUpdates() => _channel.invokeMethod<void>('stop');
  Stream<Position> get positions =>
      _positions ??= _events.receiveBroadcastStream().map(
        (event) => Position.fromMap(Map<Object?, Object?>.from(event as Map)),
      );
}
