import 'package:atitus_flutter_ui_layer/ui/holidays/holidays_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Holidays extends StatelessWidget {
  Holidays({super.key, required this.viewModel});

  final HolidaysViewModel viewModel;

  final DateFormat _dateFormat = DateFormat.yMMMMd('pt_BR');
  final customFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              if (viewModel.getHolidays.error) {
                return const Text('Erro');
              }
              return Center(
                child:
                    viewModel.holidays == null
                        ? Text('Aguardando busca de feriados...')
                        : ListView.separated(
                          separatorBuilder:
                              (context, index) => Divider(height: 1),
                          itemCount: viewModel.holidays!.length,
                          itemBuilder:
                              (context, index) => ListTile(
                                trailing: Text(
                                  _dateFormat.format(
                                    customFormat.parse(
                                      viewModel.holidays![index].date!,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  viewModel.holidays![index].name ?? 'Error',
                                ),
                                subtitle: Text(
                                  viewModel.holidays![index].localName ??
                                      'Error',
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
