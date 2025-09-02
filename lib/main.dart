import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      theme: ThemeData.dark(),
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlueAccent, Colors.blueAccent],
              stops: [0.5, 1],
            ),
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.6),
                blurRadius: 60,
                spreadRadius: 1,
                offset: Offset(0, 0),
              ),
            ],
          ),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.outlined(
                    constraints: BoxConstraints(
                      minHeight: 10.0,
                      minWidth: 10.0,
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 0.5),
                    ),
                    onPressed: () => {},
                    icon: Image.asset(
                      'assets/bottom_drawer_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.png',
                      width: 17,
                      height: 17,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => {},
                            icon: Icon(Icons.location_on),
                            color: Colors.white,
                            iconSize: 25,
                          ),
                          Text(
                            "Tuban",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ],
                      ),

                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.black,
                          ),
                        ),
                        icon: Icon(Icons.refresh),
                        onPressed: () => {},
                        label: const Text("Refresh"),
                      ),
                    ],
                  ),

                  IconButton(
                    onPressed: () => {},
                    icon: Icon(Icons.more_vert),
                    color: Colors.white,
                  ),
                ],
              ),
              Image.asset(
                'assets/forecast/cloudyDay.png',
                width: 200,
                height: 200,
              ),
              Text(
                "21",
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
              Text(
                "Cloudy",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
