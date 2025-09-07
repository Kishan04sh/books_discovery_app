import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/features/onboarding/onboarding_screen.dart';
import 'package:books_discovery_app/features/auth/login_screen.dart';
import 'package:books_discovery_app/features/auth/sign_up_screen.dart';
import 'package:books_discovery_app/features/home/home_screen.dart';
import 'package:books_discovery_app/features/home/analytics_screen.dart';
import 'package:books_discovery_app/features/home/search_screen.dart';
import 'package:books_discovery_app/features/home/contacts_screen.dart';
import 'package:books_discovery_app/features/home/profile_screen.dart';
import 'package:books_discovery_app/features/home/tabs_screen.dart';
import 'package:books_discovery_app/splash_screen.dart';
import 'package:books_discovery_app/features/Books/book_details_screen.dart';
import 'package:flutter/cupertino.dart';

import '../models/book_model.dart';



part 'app_router.gr.dart'; // Generated file

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(
      page: TabsRoute.page,
      path: '/tabs',
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: AnalyticsRoute.page),
        AutoRoute(page: SearchRoute.page),
        AutoRoute(page: ContactsRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),

    AutoRoute(page: BookDetailRoute.page),

  ];
}
