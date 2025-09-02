import 'dart:convert';
import 'package:apps/data/models/weather_class.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
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

class HomepageWeather extends StatelessWidget {
  final String teks;
  final Color color;

  const HomepageWeather({super.key, required this.teks, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text("City", style: TextStyle(fontFamily: 'Poppins')),
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
      body: Column(
        children: [
          WeatherAppBar(),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  teks,
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherAppBar extends StatefulWidget {
  @override
  State<WeatherAppBar> createState() => _WeatherAppBar();
}

class _WeatherAppBar extends State<WeatherAppBar> {
  WeatherClass? data;

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m',
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        final datas = json.decode(response.body);
        final weatherData = WeatherClass.fromJson(datas);
        data = weatherData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    'assets/forecast/cloudyDay.png',
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
                  Text("Cloudy"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
