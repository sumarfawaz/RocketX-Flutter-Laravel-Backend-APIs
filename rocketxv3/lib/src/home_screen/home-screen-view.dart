import 'package:flutter/material.dart';
import 'package:rocketxv3/src/rockets_details_screen/rockets_details_screen_view.dart';
import 'package:rocketxv3/src/settings/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userFullName = '';
  Map<String, dynamic>? weatherData;
  List<dynamic>? cryptoRates; // Variable to hold cryptocurrency rates
  List<dynamic>? rockets; // To hold rocket data
  List<dynamic>? spaceStations; // To hold space station data
  bool isLoadingRates = true; // Loading state for rates
  bool isLoadingRockets = true; // Loading state for rockets
  bool isLoadingSpaceStations = true;
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller for auto-scrolling
  // Define the webView variable
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    getUserInformation();
    fetchWeatherData(); // Fetch weather data on init
    fetchCryptoRates(); // Fetch cryptocurrency rates on init
    fetchRocketData(); // Fetch rocket data on init
    fetchSpaceStationData();
    _startAutoScroll(); // Start auto-scrolling for the crypto rates
  }

  Future<void> getUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? epassportid = prefs.getString('epassportid');

    final String apiUrl2 =
        'http://192.168.8.182:8000/api/customers/$epassportid';

    final response2 =
        await http.get(Uri.parse(apiUrl2), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response2.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(response2.body);
      setState(() {
        userFullName = user['first_name'] + ' ' + user['last_name'];
      });
    } else {
      print('Failed to get user information: ${response2.body}');
    }
  }

  Future<void> fetchWeatherData() async {
    final String apiUrl =
        'https://api.nasa.gov/insight_weather/?api_key=DEMO_KEY&feedtype=json&ver=1.0';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      final latestEntryKey = data['sol_keys'].last;
      setState(() {
        weatherData = data[latestEntryKey];
      });
    } else {
      print('Failed to fetch weather data: ${response.body}');
    }
  }

  Future<void> fetchCryptoRates() async {
    final String apiUrl =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        // Take only the first 10 records
        cryptoRates = data
            .take(10)
            .map((e) => {
                  'name': e['name'],
                  'symbol': e['symbol'].toUpperCase(),
                  'current_price': e['current_price'],
                })
            .toList();
        isLoadingRates = false; // Update loading state
      });
    } else {
      print('Failed to fetch cryptocurrency rates: ${response.body}');
      setState(() {
        isLoadingRates = false; // Stop loading on error
      });
    }
  }

  Future<void> fetchRocketData() async {
    final String apiUrl = 'http://192.168.8.182:8000/api/rockets';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        rockets = data['data']; // Access the rockets data array
        isLoadingRockets = false; // Update loading state
      });
    } else {
      print('Failed to fetch rocket data: ${response.body}');
      setState(() {
        isLoadingRockets = false; // Stop loading on error
      });
    }
  }

  Future<void> fetchSpaceStationData() async {
    final String apiUrl =
        'http://192.168.8.182:8000/api/spacestations'; // Update the API URL as needed
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        spaceStations = data['data']; // Access the space station data array
        isLoadingSpaceStations = false; // Update loading state
      });
    } else {
      print('Failed to fetch space station data: ${response.body}');
      setState(() {
        isLoadingSpaceStations = false; // Stop loading on error
      });
    }
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted && _scrollController.hasClients) {
        setState(() {
          // Trigger a scroll
          _scrollController.jumpTo(_scrollController.position.pixels + 200);
        });

        // Reset scroll position if we reached the end
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel(); // Cancel the auto-scroll timer
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  // Function to get the appropriate image for the rocket
  String getRocketImage(String rocketName) {
    if (rocketName.contains('Falcon')) {
      return 'assets/images/falcon.png';
    } else if (rocketName.contains('SpaceX')) {
      return 'assets/images/spacex.png';
    } else if (rocketName.contains('CHI')) {
      return 'assets/images/china_flag.png';
    }
    return 'assets/images/default.png'; // Default image
  }

  String spaceStationImage(String spaceStationName) {
    if (spaceStationName.contains('Mars')) {
      return 'assets/images/mars.jpg';
    } else if (spaceStationName.contains('Saturn')) {
      return 'assets/images/saturn.png';
    } else if (spaceStationName.contains('Uranus')) {
      return 'assets/images/uranus.png';
    } else if (spaceStationName.contains('Jupiter')) {
      return 'assets/images/jupiter.jpg';
    }
    return 'assets/images/planet.png'; // Default image
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Greeting message
            Center(
              child: Text(
                '${DateTime.now().hour < 12 ? 'Good Morning' : 'Good Afternoon'}, $userFullName',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text("Weather on Mars today?",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                )),
            // Weather data display
            if (weatherData != null)
              Center(
                child: _buildWeatherDisplay(),
              )
            else
              const Center(child: CircularProgressIndicator()),

            const SizedBox(height: 20),
            // Cryptocurrency Rates Section
            const SizedBox(height: 10),
            // Display cryptocurrency rates in an auto-scrolling view
            isLoadingRates
                ? const Center(child: CircularProgressIndicator())
                : cryptoRates != null && cryptoRates!.isNotEmpty
                    ? SizedBox(
                        height: 50, // Set height for the ticker
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: cryptoRates!.length,
                          itemBuilder: (context, index) {
                            final rate = cryptoRates![index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 248, 248, 248),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${rate['name']} (${rate['symbol']}): \$${rate['current_price'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 68, 5, 5),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(child: Text("No rates available.")),

            const SizedBox(height: 30),
            // Rocket Data Section
            const Text("Rockets",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                )),
            const SizedBox(height: 10),
            isLoadingRockets
                ? const Center(child: CircularProgressIndicator())
                : rockets != null && rockets!.isNotEmpty
                    ? SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: rockets!.length,
                          itemBuilder: (context, index) {
                            final rocket = rockets![index];
                            final rocketName = rocket['rocketname'];

                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RocketDetailsScreen(rocket: rocket),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 5,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Container(
                                    width: 300,
                                    height: 150,
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          getRocketImage(rocketName),
                                          width: 150,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          rocketName,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        ),
                      )
                    : const Center(child: Text("No rocket data available.")),

            // Space Station Fetch
            const SizedBox(height: 30),
            const Text("Space Stations",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                )),
            const SizedBox(height: 10),
            isLoadingSpaceStations
                ? const Center(child: CircularProgressIndicator())
                : spaceStations != null && spaceStations!.isNotEmpty
                    ? SizedBox(
                        height: 200, // Set a height for the ListView
                        child: ListView.builder(
                          scrollDirection:
                              Axis.horizontal, // Ensure horizontal scrolling
                          itemCount: spaceStations!.length,
                          itemBuilder: (context, index) {
                            final spaceStation = spaceStations![index];
                            final spaceStationName =
                                spaceStation['spacestation_name'];

                            return Card(
                              elevation: 5,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Container(
                                width: 300,
                                height: 150,
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      spaceStationImage(spaceStationName),
                                      width: 150,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      spaceStationName,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text("No space station data available."),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDisplay() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWeatherColumn('Avg Temp', '${weatherData!['AT']['av']} °C'),
            _buildWeatherColumn('Max Temp', '${weatherData!['AT']['mx']} °C'),
            _buildWeatherColumn(
                'Avg Wind Speed', '${weatherData!['HWS']['av']} m/s'),
            _buildWeatherColumn('Season', weatherData!['Season']),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherColumn(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
