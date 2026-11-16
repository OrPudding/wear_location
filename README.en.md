# wear_location

[简体中文](README.md) | English

Native Android and iOS location for Flutter applications, with one-shot fixes, continuous updates, permission checks, and location-service status

## Integration

Add this repository as a Git dependency in `pubspec.yaml` and pin `ref` to the required commit

Import `package:wear_location/wear_location.dart` and use `WearLocation.instance`

Use `getCurrentPosition` for a one-shot fix, with configurable timeout and maximum cache age. Cancel a pending request with `cancelCurrentPosition`

Use `startUpdates`, read positions from `positions`, and call `stopUpdates` to stop continuous updates. The host manages the shared session

## Platforms

| Platform | Implementation | Continuous updates |
|---|---|---|
| Android | `LocationManager` | Location foreground service |
| iOS | Core Location | Background location updates |

Check service availability and request precise-location permission before use. The host serializes start and stop calls

The Android plugin Manifest declares location permissions and the foreground service. The host supplies notification text and the channel name

The iOS host configures `NSLocationWhenInUseUsageDescription` in `Info.plist`. Background location also requires `NSLocationAlwaysAndWhenInUseUsageDescription` and the `location` entry in `UIBackgroundModes`

The native implementation is compiled with the host application

## Local development

The Flutter version is specified in `.fvmrc`

~~~sh
fvm flutter pub get
fvm flutter analyze
fvm flutter test
~~~

CI runs Dart checks and tests, Android plugin compilation, and an iOS Swift bridge type check

## License

[AGPL-3.0](LICENSE)
