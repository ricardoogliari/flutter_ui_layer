import 'package:atitus_flutter_ui_layer/data/repositories/repository.dart';
import 'package:atitus_flutter_ui_layer/data/services/api/api_client.dart';
import 'package:atitus_flutter_ui_layer/router.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting('pt_BR').then(
    (_) => runApp(
      MultiProvider(
        providers: [
          Provider(create: (context) => APIClient()),
          Provider<Repository>(
            create: (context) => RepositoryImpl(client: context.read()),
          ),
        ],
        child: MaterialApp.router(routerConfig: router()),
      ),
    ),
  );
}
