import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

const apiKey = '4e7e12104089e40237206f1c39f1ba50';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  bool isLoading = false;
  bool fetchingError = true;
  String _location = 'Your location';
  String _temperature = 'N/A';
  String _weatherDescription = 'N/A';
  String _max = "N/A";
  String _min = "N/A";
  Image _weatherIcon = Image.network("https://www.noaa.gov/weather");

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  Future<void> _getWeather() async {
    isLoading = true;
    fetchingError = false;
    setState(() {});
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=Dhaka&units=metric&appid=$apiKey");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      _location = jsonData['name'];
      _temperature = jsonData['main']['temp'].toString();
      _min = jsonData['main']['temp_min'].toString();
      _max = jsonData['main']['temp_max'].toString();

      _weatherDescription = jsonData['weather'][0]['description'];
      _weatherIcon = Image.network(
        'https://openweathermap.org/img/wn/${jsonData['weather'][0]['icon']}.png',
      );
      setState(() {});
    } else {
      _temperature = 'N/A';
      _weatherDescription = 'N/A';
      _weatherIcon = Image.network(
        "https://www.noaa.gov/weather",
      );
      setState(() {});
    }
    isLoading = false;
    fetchingError = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Flutter Weather App',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : fetchingError
              ? const Center(
                  child:
                      Text("There is a error in fetching the data from api!"),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color(0xFF701ebd),
                    Color(0xFF873bcc),
                    Color(0xFFfe4a97),
                    // Color(0xFFe17763),
                    // Color(0xFF68998c),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _location,
                          style: GoogleFonts.acme(fontSize: 45),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _weatherIcon,
                            const SizedBox(
                              width: 50,
                            ),
                            Text(
                              "$_temperature °C",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Column(
                              children: [
                                Text("$_max °C"),
                                Text("$_min °C"),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          _weatherDescription,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
