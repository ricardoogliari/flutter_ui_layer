import 'package:atitus_flutter_ui_layer/routes.dart';
import 'package:atitus_flutter_ui_layer/ui/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              if (viewModel.getAvailableCountries.error) {
                return const Text('Erro');
              }
              return Center(
                child:
                    viewModel.availableCountries == null
                        ? Text('Aguardando países disponíveis...')
                        : ListView.separated(
                          separatorBuilder:
                              (context, index) => Divider(height: 1),
                          itemCount: viewModel.availableCountries!.length,
                          itemBuilder:
                              (context, index) => ListTile(
                                title: Text(
                                  viewModel.availableCountries![index].name ??
                                      'Error',
                                ),
                                subtitle: Text(
                                  viewModel
                                          .availableCountries![index]
                                          .countryCode ??
                                      'Error',
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    context.push(
                                      Routes.holidayWithCountryCode(
                                        viewModel
                                                .availableCountries![index]
                                                .countryCode ??
                                            'BR',
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.arrow_right),
                                ),
                              ),
                        ),
              );
            },
          ),
        ),
      ),
    );
  }
}
