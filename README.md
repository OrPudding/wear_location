# wear_location

简体中文 | [English](README.en.md)

为 Flutter 应用提供 Android 与 iOS 原生定位，支持单次定位、持续位置更新、权限检查和定位服务状态查询

## 接入

在 `pubspec.yaml` 中添加本仓库的 Git 依赖，并将 `ref` 固定到所需提交

Dart 入口为 `package:wear_location/wear_location.dart`，通过 `WearLocation.instance` 调用

单次定位使用 `getCurrentPosition`，可设置超时时间和可接受的缓存时长，通过 `cancelCurrentPosition` 取消请求

持续定位使用 `startUpdates` 启动，从 `positions` 接收位置，通过 `stopUpdates` 停止，共享会话由宿主管理

## 平台支持

| 平台 | 实现 | 持续定位 |
|---|---|---|
| Android | `LocationManager` | 定位前台服务 |
| iOS | Core Location | 后台位置更新 |

定位前需检查服务状态并申请精确位置权限，持续定位的启停调用需由宿主串行执行

Android 定位权限与前台服务已在插件 Manifest 中声明，通知标题、内容和渠道名称由宿主传入

iOS 宿主需在 `Info.plist` 配置 `NSLocationWhenInUseUsageDescription`，后台定位还需配置 `NSLocationAlwaysAndWhenInUseUsageDescription` 与 `UIBackgroundModes` 的 `location` 项

原生实现随宿主应用编译

## 本地开发

Flutter 版本由 `.fvmrc` 指定

```sh
fvm flutter pub get
fvm flutter analyze
fvm flutter test
```

CI 执行 Dart 检查与测试、Android 插件编译和 iOS Swift 桥接类型检查

## 许可证

本项目采用 [AGPL-3.0](LICENSE)
