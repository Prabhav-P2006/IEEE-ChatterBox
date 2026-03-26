import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../features/chat/presentation/pages/main_screen.dart';
import '../../features/chat/presentation/pages/message_screen.dart';
import '../../features/chat/presentation/pages/setting_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: MainRoute.page, initial: true),
    AutoRoute(page: MessageRoute.page),
    AutoRoute(page: SettingRoute.page),
  ];
}
