import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _stations = [
    'ND - Nadiad Jn',
    'RJT - Rajkot Jn',
    'BCT - Mumbai Central',
    'ST - Surat',
    'ADI - Ahmedabad Jn'
  ];

  String _selectedSource = 'ND - Nadiad Jn';
  String _selectedDestination = 'RJT - Rajkot Jn';
  DateTime _selectedDate = DateTime.now();
  List<Map<String, String>> _trainDetailsList = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> fetchTrainDetails() async {
    final fromStationCode = _getStationCode(_selectedSource);
    final toStationCode = _getStationCode(_selectedDestination);

    final url = Uri.parse(
        'https://irctc1.p.rapidapi.com/api/v3/getPNRStatus');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final document = parse(response.body);

        // Find the HTML elements containing the train data
        final trainElements = document.querySelectorAll('.TrainSearchSection');

        // Clear the previous train details
        _trainDetailsList.clear();

        for (var element in trainElements) {
          // Extract train details such as name, number, departure, arrival, and duration
          String trainName = element.querySelector('.train-name')?.text.trim() ?? 'Unknown';
          String trainNumber = element.querySelector('.train-number')?.text.trim() ?? 'Unknown';
          String departureTime = element.querySelector('.departure-time')?.text.trim() ?? 'Unknown';
          String arrivalTime = element.querySelector('.arrival-time')?.text.trim() ?? 'Unknown';
          String duration = element.querySelector('.duration')?.text.trim() ?? 'Unknown';

          // Store each train's details in a map
          _trainDetailsList.add({
            'name': trainName,
            'number': trainNumber,
            'departure': departureTime,
            'arrival': arrivalTime,
            'duration': duration,
          });
        }

        setState(() {
          // If no trains found, set the message
          if (_trainDetailsList.isEmpty) {
            _trainDetailsList = [{'name': 'No trains found for the selected route.', 'number': '', 'departure': '', 'arrival': '', 'duration': ''}];
          }
        });
      } else {
        setState(() {
          _trainDetailsList = [{'name': 'Failed to load train details', 'number': '', 'departure': '', 'arrival': '', 'duration': ''}];
        });
      }
    } catch (e) {
      setState(() {
        _trainDetailsList = [{'name': 'An error occurred: $e', 'number': '', 'departure': '', 'arrival': '', 'duration': ''}];
      });
    }
  }

  String _getStationCode(String stationName) {
    switch (stationName) {
      case 'ND - Nadiad Jn':
        return 'ND';
      case 'RJT - Rajkot Jn':
        return 'RJT';
      case 'BCT - Mumbai Central':
        return 'BCT';
      case 'ST - Surat':
        return 'ST';
      case 'ADI - Ahmedabad Jn':
        return 'ADI';
      default:
        return 'ND'; // Default value or handle it accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Train Booking'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('Register'),
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.train),
                labelText: 'Source',
                border: OutlineInputBorder(),
              ),
              value: _selectedSource,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSource = newValue!;
                });
              },
              items: _stations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.train),
                labelText: 'Destination',
                border: OutlineInputBorder(),
              ),
              value: _selectedDestination,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDestination = newValue!;
                });
              },
              items: _stations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: 'Travel Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        DateFormat.yMMMEd().format(_selectedDate),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: fetchTrainDetails,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Search Trains',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _trainDetailsList.length,
                itemBuilder: (context, index) {
                  final train = _trainDetailsList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${train['name']} (${train['number']})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Departure: ${train['departure']}'),
                          Text('Arrival: ${train['arrival']}'),
                          Text('Duration: ${train['duration']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
