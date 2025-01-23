import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherSection extends StatefulWidget {
  const WeatherSection({Key? key}) : super(key: key);

  @override
  State<WeatherSection> createState() => _WeatherSectionState();
}

class _WeatherSectionState extends State<WeatherSection> {
  static const String apiKey = "935693816889474b854102533252101";
  static const String baseUrl = "http://api.weatherapi.com/v1";

  late Future<Map<String, dynamic>> _currentWeather;
  late Future<List<dynamic>> _hourlyForecast;
  late Future<List<Map<String, dynamic>>> _dailyForecast;

  @override
  void initState() {
    super.initState();
    const String location = "Almaty"; // Updated location
    _currentWeather = getCurrentWeather(location);
    _hourlyForecast = getHourlyForecast(location);
    _dailyForecast = getDailyForecast(location);
  }

  Future<Map<String, dynamic>> getCurrentWeather(String location) async {
    final url = Uri.parse("$baseUrl/current.json?key=$apiKey&q=$location");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load current weather data");
    }
  }

  Future<List<dynamic>> getHourlyForecast(String location) async {
    final url = Uri.parse("$baseUrl/forecast.json?key=$apiKey&q=$location&days=1");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['forecast']['forecastday'][0]['hour'];
    } else {
      throw Exception("Failed to load hourly forecast data");
    }
  }

  Future<List<Map<String, dynamic>>> getDailyForecast(String location) async {
    final url = Uri.parse("$baseUrl/forecast.json?key=$apiKey&q=$location&days=3");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['forecast']['forecastday'] as List)
          .map((day) => {
                'date': day['date'],
                'temp': day['day']['avgtemp_c'],
                'weather': day['day']['condition']['text'],
              })
          .toList();
    } else {
      throw Exception("Failed to load daily forecast data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _currentWeather,
        _hourlyForecast,
        _dailyForecast,
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          final currentWeather = snapshot.data![0] as Map<String, dynamic>;
          final hourlyForecast = snapshot.data![1] as List<dynamic>;
          final dailyForecast = snapshot.data![2] as List<Map<String, dynamic>>;

          return _buildWeatherSection(
            currentWeather: currentWeather,
            hourlyForecast: hourlyForecast,
            dailyForecast: dailyForecast,
          );
        }
      },
    );
  }

  Widget _buildWeatherSection({
    required Map<String, dynamic> currentWeather,
    required List<dynamic> hourlyForecast,
    required List<Map<String, dynamic>> dailyForecast,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFF0B1D26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WeatherInfo(
                icon: Icons.water_drop,
                label: '${currentWeather['current']['humidity']}%',
                value: 'Humidity',
              ),
              WeatherInfo(
                icon: Icons.thermostat,
                label: '${currentWeather['current']['temp_c']}°C',
                value: 'Temperature',
              ),
              WeatherInfo(
                icon: Icons.wind_power,
                label: '${currentWeather['current']['wind_kph']} km/h',
                value: 'Wind',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Hourly Forecast',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourlyForecast.length,
              itemBuilder: (context, index) {
                final forecast = hourlyForecast[index];
                final time = forecast['time'].split(' ')[1];
                final temp = forecast['temp_c'];
                final icon = Icons.wb_sunny; // Replace with dynamic icon mapping
                return HourlyWeatherTile(
                  time: time,
                  temp: '${temp.toStringAsFixed(1)}°C',
                  icon: icon,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '3-Day Forecast',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ...dailyForecast.map((forecast) {
            final date = forecast['date'];
            final temp = forecast['temp'];
            final weather = forecast['weather'];
            final icon = Icons.cloud; // Replace with dynamic icon mapping

            return ListTile(
              leading: Icon(icon, color: Colors.white),
              title: Text(
                date,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Text(
                '${temp.toStringAsFixed(1)}°C',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class WeatherInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class HourlyWeatherTile extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;

  const HourlyWeatherTile({
    super.key,
    required this.time,
    required this.temp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            temp,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
