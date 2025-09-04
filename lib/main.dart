import 'dart:convert';
import 'package:apps/data/geocoding/cod.dart';
import 'package:apps/data/models/weather_class.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => WeatherApp()),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      theme: ThemeData.light(),
      title: "Homepage",
      home: HomepageWeather(teks: "Homepage", color: Colors.blue),
    );
  }
}

class HomepageWeather extends StatefulWidget {
  const HomepageWeather({super.key, required this.teks, required this.color});

  final String teks;
  final Color color;
  @override
  State<HomepageWeather> createState() => _HomepageWeather();
}

class _HomepageWeather extends State<HomepageWeather> {
  void initState() {
    super.initState();
    getAddress();
  }

  String addreess = '';
  String apiKey = dotenv.env['OPENCAGE_API_KEY'] ?? "";
  Future<void> getAddress() async {
    final result = await getAddressFromCoordinates(52.52, 13.41, apiKey);
    setState(() {
      addreess = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(addreess, style: TextStyle(fontFamily: 'Poppins')),
            Text(
              "12.00",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WeatherAppBar(),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Center(
                child: Text(
                  widget.teks,
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherAppBar extends StatefulWidget {
  const WeatherAppBar({super.key});

  @override
  State<WeatherAppBar> createState() => _WeatherAppBar();
}

class _WeatherAppBar extends State<WeatherAppBar> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  WeatherClass? data;
  String? weatherDescription;
  String? address = '';
  String resultWeather = '';

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m,weather_code',
      ),
    );
    if (response.statusCode == 200) {
      final datas = json.decode(response.body);
      final weatherData = WeatherClass.fromJson(datas);
      setState(() {
        data = weatherData;
        weatherDescription = classification(data);
      });
      spesification();
    }
  }

  Future<void> spesification() async {
    //
    // ASSETS THAT I GOT FROM:
    // https://www.figma.com/community/file/1475148761806819630
    // https://www.figma.com/community/file/1213472613903351253
    //

    switch (weatherDescription) {
      case 'Clear':
        resultWeather = "clear.png";
        break;
      case 'Cloudy':
        resultWeather = "cloudyDay.png";
        break;
      case 'Fog':
        resultWeather = "fog.png";
        break;
      case 'Drizzle':
        resultWeather = 'drizzle.png';
        break;
      case 'Freezing drizzle':
        resultWeather = 'drizzleSnow.png';
        break;
      case 'Rain':
        resultWeather = 'rain.png';
        break;
      // not yet implemented now....
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  stops: [0.5, 1],
                ),
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 1,
                    offset: Offset(0, 0),
                  ),
                ],
              ),

              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -20, // posisi melayang ke atas
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          elevation: 8,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shadowColor: Colors.black45,
                        ),
                        onPressed: () {},
                        child: Text("Sunday, 2 Sep 2025"),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [SizedBox(), SizedBox()],
                      ),
                      SizedBox(height: 20),
                      Image.asset(
                        'assets/forecast/$resultWeather',
                        width: 140,
                        height: 140,
                      ),
                      Text(
                        data != null
                            ? data!.hourly.temperature2m[0].toStringAsFixed(0)
                            : "N/A",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 100,
                          fontFamily: "Poppins",
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.lightBlueAccent,
                              offset: Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 40,
                              color: Colors.white.withOpacity(0.5),
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      Text(weatherDescription ?? "N/A"),
                      Text(address ?? "N/A"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.0, right: 22.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        //
        // List forecast
        //
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(4, (index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Day $index",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

String classification(WeatherClass? data) {
  if (data == null || data.hourly.weatherCode.isEmpty) return "unknown";

  int code = data.hourly.weatherCode[0];

  if (code == 0) return "Clear";
  if ([1, 2, 3].contains(code)) return "Cloudy";
  if ([45, 48].contains(code)) return "Fog";
  if ([51, 53, 55].contains(code)) return "Drizzle";
  if ([56, 57].contains(code)) return "Freezing drizzle";
  if ([61, 63, 65].contains(code)) return "Rain";
  if ([66, 67].contains(code)) return "Freezing rain";
  if ([71, 73, 75].contains(code)) return "Snow";
  if (code == 77) return "Snow grains";
  if ([80, 81, 82].contains(code)) return "Rain showers";
  if ([85, 86].contains(code)) return "Snow showers";
  if (code == 95) return "Thunderstorm";
  if ([96, 99].contains(code)) return "Thunderstorm with hail";

  return "unknown";
}
