class WeatherClass {
  final double latitude;
  final double longitude;
  final double generationTimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final double elevation;
  final HourlyUnits hourlyUnits;
  final Hourly hourly;

  WeatherClass({
    required this.latitude,
    required this.longitude,
    required this.generationTimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.hourlyUnits,
    required this.hourly,
  });

  factory WeatherClass.fromJson(Map<String, dynamic> json) {
    return WeatherClass(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      generationTimeMs: json['generationtime_ms'].toDouble(),
      utcOffsetSeconds: json['utc_offset_seconds'],
      timezone: json['timezone'],
      timezoneAbbreviation: json['timezone_abbreviation'],
      elevation: json['elevation'].toDouble(),
      hourlyUnits: HourlyUnits.fromJson(json['hourly_units']),
      hourly: Hourly.fromJson(json['hourly']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'generationtime_ms': generationTimeMs,
      'utc_offset_seconds': utcOffsetSeconds,
      'timezone': timezone,
      'timezone_abbreviation': timezoneAbbreviation,
      'elevation': elevation,
      'hourly_units': hourlyUnits.toJson(),
      'hourly': hourly.toJson(),
    };
  }
}

class HourlyUnits {
  final String time;
  final String temperature2m;

  HourlyUnits({required this.time, required this.temperature2m});

  factory HourlyUnits.fromJson(Map<String, dynamic> json) {
    return HourlyUnits(
      time: json['time'],
      temperature2m: json['temperature_2m'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'time': time, 'temperature_2m': temperature2m};
  }
}

class Hourly {
  final List<String> time;
  final List<double> temperature2m;
  final List<int> weatherCode;

  Hourly({
    required this.time,
    required this.temperature2m,
    required this.weatherCode,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) {
    return Hourly(
      time: List<String>.from(json['time']),
      temperature2m: List<double>.from(
        json['temperature_2m'].map((x) => x.toDouble()),
      ),
      weatherCode: List<int>.from(json['weather_code']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m': temperature2m,
      'weather_code': weatherCode,
    };
  }
}
