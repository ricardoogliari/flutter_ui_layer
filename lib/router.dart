// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:atitus_flutter_ui_layer/ui/holidays/holidays.dart';
import 'package:atitus_flutter_ui_layer/ui/holidays/holidays_view_model.dart';
import 'package:atitus_flutter_ui_layer/ui/home/home.dart';
import 'package:atitus_flutter_ui_layer/ui/home/home_view_model.dart';
import 'package:atitus_flutter_ui_layer/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Top go_router entry point.
///
/// Listens to changes in [AuthTokenRepository] to redirect the user
/// to /login when the user logs out.
GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        final viewModel = HomeViewModel(repository: context.read());
        return Home(viewModel: viewModel);
      },
      routes: [
        GoRoute(
          path: Routes.holidaysRelative,
          builder: (context, state) {
            final viewModel = HolidaysViewModel(repository: context.read());

            return Holidays(viewModel: viewModel);
          },
          routes: [
            GoRoute(
              path: ':countryCode',
              builder: (context, state) {
                final countryCode = state.pathParameters['countryCode']!;
                final viewModel = HolidaysViewModel(repository: context.read());

                viewModel.getHolidays.execute(countryCode);

                return Holidays(viewModel: viewModel);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
