import 'package:flutter/material.dart';

class RocketDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> rocket;

  const RocketDetailsScreen({Key? key, required this.rocket}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          rocket['rocketname'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change back button color to white
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  getRocketImage(rocket['rocketname']),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  rocket['rocketname'],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Rocket data section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rocket Specifications",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      Text(
                        'Height: ${rocket['height']} meters',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Diameter: ${rocket['diameter']} meters',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Mass: ${rocket['mass']} tons',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Payload to LEO: ${rocket['payloadtoleo']} kg',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Payload to GTO: ${rocket['payloadtogto']} kg',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Payload to Mars: ${rocket['payloadtomars']} kg',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Additional information section (you can add more rocket details)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Additional Information",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      Text(
                        'Created at: ${rocket['created_at']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
