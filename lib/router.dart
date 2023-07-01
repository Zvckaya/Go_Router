import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'constants.dart';
import 'login_state.dart';
import 'ui/cart.dart';
import 'ui/create_account.dart';
import 'ui/error_page.dart';
import 'ui/home_screen.dart';
import 'ui/login.dart';
import 'ui/personal_info.dart';
import 'ui/profile.dart';
import 'ui/shopping.dart';

class MyRouter {
  final LoginState loginState;
  MyRouter({required this.loginState});

  late final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
          path: '/login',
          name: loginRouteName,
          builder: ((context, state) {
            return const Login();
          })),
      GoRoute(
          path: '/create-account',
          name: createAccountRouteName,
          builder: ((context, state) {
            return const CreateAccount();
          })),
      GoRoute(
        path: '/:tab',
        name: rootRouteName,
        builder: ((context, state) {
          return HomeScreen(
            tab: state.pathParameters['tab'] ?? '',
          );
        }),
        routes: [
          GoRoute(
            path: 'personal',
            name: profilePersonalRouteName,
            builder: (context, state) {
              return const PersonalInfo();
            },
          )
        ],
      )
    ],
    redirect: (context, state) {
      final loggedIn = loginState.loggedIn;
      final inAuthPages = state.location.contains(loginRouteName) ||
          state.location.contains(createAccountRouteName);

      if (loggedIn && inAuthPages) return '/profile';
      if (!loggedIn && !inAuthPages) return '/login';
    },
    errorPageBuilder: (context, state) {
      return MaterialPage<void>(child: ErrorPage());
    },
    refreshListenable: loginState,
    debugLogDiagnostics: true,
  );
}
