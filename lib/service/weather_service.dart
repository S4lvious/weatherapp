
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/model/weather-model.dart';

class WeatherService {


    static final dio = Dio();

    static Future<WeatherData> getWeatherData() async {
    final currentPosition = await _getCurrentPosition();
    final String url =
        "https://api.open-meteo.com/v1/forecast?latitude=${currentPosition.latitude}&longitude=${currentPosition.longitude}&current=temperature_2m,is_day,rain&hourly=temperature_2m,is_day&timezone=auto&forecast_days=1";
    final response = await dio.get(url);
    return WeatherData.fromJson(response.data);
  }


  static Future<List<Placemark>> getCurrentLocation() async {
    final currentPosition = await _getCurrentPosition();
    final List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    return placemarks;
  }

    static Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    final position = await Geolocator.getCurrentPosition();
    return position;
  }


}