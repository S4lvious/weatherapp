import 'package:flutter/material.dart';
import 'package:weatherapp/model/weather-model.dart';

class HourlyWeather extends StatelessWidget {
const HourlyWeather({Key? key, required this.weatherData}) : super(key: key);
    final WeatherData weatherData;
    
        @override
          Widget build(BuildContext context) {
          final hourlyData = weatherData.hourly;
          return Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "PREVISIONE ORARIA",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                    width: double.infinity, height: 1, color: Colors.white12),
                Expanded(
                  child: ListView.separated(
                    itemCount: hourlyData.temperature2M.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        "${hourlyData.time[index].hour}:00",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        "${hourlyData.temperature2M[index]}°",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    separatorBuilder: (context, index) => Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white12),
                  ),
                )
              ],
            ),
          );
  }
}