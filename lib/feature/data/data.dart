import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:data_table_2/data_table_2.dart'; // Подключите DataTable2

void main() {
  runApp(const MaterialApp(
    home: NewsPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  Future<List<Map<String, dynamic>>> fetchWeatherData() async {
    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:8000/api/weather-data/'), // Укажите ваш URL API
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Data'),
        backgroundColor: const Color(0xFF0B1D26),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchWeatherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Нет данных для отображения.'),
            );
          } else {
            final data = snapshot.data!;
            return SizedBox(
              width: double.infinity,
              height: 400, // Ограничиваем высоту таблицы
              child: PaginatedDataTable2(
                columns: const [
                  DataColumn(
                    label: Text('Дата',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Средняя Температура',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Макс. Температура',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Мин. Температура',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Риск Паводков',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
                source: WeatherDataSource(data),
                columnSpacing: 16,
                horizontalMargin: 20,
                minWidth: 800,
                rowsPerPage: 5, // Количество строк на странице
                sortColumnIndex: 0, // Индекс сортируемой колонки
                sortAscending: true, // Направление сортировки
              ),
            );
          }
        },
      ),
    );
  }
}

class WeatherDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;

  WeatherDataSource(this.data);

  @override
  DataRow getRow(int index) {
    final weather = data[index];
    return DataRow(cells: [
      DataCell(Text(weather['date'] ?? 'N/A')),
      DataCell(Text('${weather['air_temp_avg'] ?? 0.0} °C')),
      DataCell(Text('${weather['air_temp_max'] ?? 0.0} °C')),
      DataCell(Text('${weather['air_temp_min'] ?? 0.0} °C')),
      DataCell(Text('${weather['flood_risk'] ?? 0.0} %')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}