class WeatherData {
  final double latitude;
  final double longitude;
  final double generationTimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final double elevation;
  final CurrentData current;
  final HourlyData hourly;

  WeatherData({
    required this.latitude,
    required this.longitude,
    required this.generationTimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.current,
    required this.hourly,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      generationTimeMs: json['generationtime_ms'] as double,
      utcOffsetSeconds: json['utc_offset_seconds'] as int,
      timezone: json['timezone'] as String,
      timezoneAbbreviation: json['timezone_abbreviation'] as String,
      elevation: json['elevation'] as double,
      current: CurrentData.fromJson(json['current']),
      hourly: HourlyData.fromJson(json['hourly']),
    );
  }
}

class CurrentData {
  final DateTime time;
  final int interval;
  final double temperature2M;
  final bool isDay;
  final bool rain;

  CurrentData({
    required this.time,
    required this.interval,
    required this.temperature2M,
    required this.isDay,
    required this.rain,
  });

  factory CurrentData.fromJson(Map<String, dynamic> json) {
    return CurrentData(
      time: DateTime.parse(json['time']),
      interval: json['interval'] as int,
      temperature2M: json['temperature_2m'] as double,
      isDay: json['is_day'] == 1,
      rain: json['rain'] == 1,
    );
  }
}

class HourlyData {
  final List<DateTime> time;
  final List<double> temperature2M;
  final List<bool> isDay;

  HourlyData({
    required this.time,
    required this.temperature2M,
    required this.isDay,
  });

  factory HourlyData.fromJson(Map<String, dynamic> json) {
    return HourlyData(
      time: (json['time'] as List).map((t) => DateTime.parse(t)).toList(),
      temperature2M: (json['temperature_2m'] as List).map((t) => (t as num).toDouble()).toList(),
      isDay: (json['is_day'] as List).map((i) => i == 1).toList(),
    );
  }
}