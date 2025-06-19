// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

abstract final class Routes {
  static const home = '/';
  static const holidays = '/$holidaysRelative';
  static const holidaysRelative = 'holidays';
  static String holidayWithCountryCode(String countryCode) =>
      '$holidays/$countryCode';
}
