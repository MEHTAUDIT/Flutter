import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:lab/screens/side.dart';

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

  String _getStationCode(String stationName) {
    switch (stationName) {
      case 'ND - Nadiad Jn':
        return 'nadiad';
      case 'RJT - Rajkot Jn':
        return 'rajkot';
      case 'BCT - Mumbai Central':
        return 'mumbai';
      case 'ST - Surat':
        return 'surat';
      case 'ADI - Ahmedabad Jn':
        return 'ahmedabad';
      default:
        return 'ND'; // Default or fallback code
    }
  }

  void _searchTrains() {
    // Gather the data
    final sourceCode = _getStationCode(_selectedSource);
    final destinationCode = _getStationCode(_selectedDestination);
    final date = DateFormat('yyyy-MM-dd').format(_selectedDate);

    print('Source Code: $sourceCode');
    print('Destination Code: $destinationCode');
    print('Date: $date');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Train Booking'),
      ),
      drawer: const SideDrawer(), // Pass login status to SideDrawer
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
              onPressed: _searchTrains,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Search Trains',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            // Additional widgets such as train details list will go here
          ],
        ),
      ),
    );
  }
}
